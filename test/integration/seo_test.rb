require "test_helper"

class SeoTest < ActionDispatch::IntegrationTest
  test "home exposes canonical social metadata and structured data" do
    host! "vianpropiedades.cl"
    get root_path

    assert_response :success
    assert_select "title", text: /Vian Propiedades/
    assert_select "meta[name=description][content]", count: 1
    assert_select "meta[name=robots][content='index, follow, max-image-preview:large']", count: 1
    assert_select "link[rel=canonical][href='https://vianpropiedades.cl/']", count: 1
    assert_select "meta[property='og:image'][content='https://vianpropiedades.cl/og-vian-propiedades.jpg']", count: 1
    assert_select "meta[name='twitter:card'][content='summary_large_image']", count: 1
    assert_select "link[rel=icon][href='/favicon.ico']", count: 1
    assert_select "link[rel=icon][href='/vian-favicon-32.png']", count: 1
    assert_select "link[rel=apple-touch-icon][href='/vian-apple-touch-icon.png']", count: 1

    data = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    types = data.fetch("@graph").flat_map { |entry| Array(entry["@type"]) }
    assert_includes types, "RealEstateAgent"
    assert_includes types, "WebSite"
  end

  test "property metadata describes the listing and filtered catalogs are not indexed" do
    property = propiedades(:one)
    host! "vianpropiedades.cl"
    get propiedad_path(property)

    assert_response :success
    assert_select "title", text: /#{Regexp.escape(property.titulo)}/
    assert_select "link[rel=canonical][href=?]", "https://vianpropiedades.cl#{propiedad_path(property)}"
    assert_select "meta[property='og:image'][content^='https://vianpropiedades.cl/']", count: 1
    data = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    assert_includes data.fetch("@graph").map { |entry| entry["@type"] }, "RealEstateListing"

    get propiedades_path, params: { tipo_transaccion: "venta" }
    assert_select "meta[name=robots][content='noindex, follow']", count: 1
    assert_select "link[rel=canonical][href='https://vianpropiedades.cl/propiedades']", count: 1
  end

  test "property metadata uses an attached gallery image" do
    property = propiedades(:one)
    property.imagenes.attach(
      io: File.open(Rails.root.join("app/assets/images/img_1.jpg")),
      filename: "propiedad.jpg",
      content_type: "image/jpeg"
    )
    host! "vianpropiedades.cl"

    get propiedad_path(property)

    assert_response :success
    assert_select "meta[property='og:image'][content*='/rails/active_storage/representations/']", count: 1
  end

  test "legacy home URL redirects permanently to the canonical home" do
    get home_index_path

    assert_response :moved_permanently
    assert_redirected_to root_path
  end

  test "sitemap contains only public listing URLs" do
    hidden = propiedades(:two)
    hidden.update!(publicada: false)
    host! "vianpropiedades.cl"
    get sitemap_path(format: :xml)

    assert_response :success
    assert_equal "application/xml", response.media_type
    assert_includes response.body, "https://vianpropiedades.cl#{propiedad_path(propiedades(:one))}"
    assert_not_includes response.body, "https://vianpropiedades.cl#{propiedad_path(hidden)}"
  end
end
