require "test_helper"

class PropiedadesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
    @propiedad = propiedades(:one)
  end

  test "should get index" do
    get propiedades_url
    assert_response :success
  end

  test "should get new" do
    get new_propiedad_url
    assert_response :success
  end

  test "should create propiedad" do
    assert_difference("Propiedad.count") do
      post propiedades_url, params: { propiedad: { banos: @propiedad.banos, comuna_id: @propiedad.comuna_id, descripcion: @propiedad.descripcion, dormitorios: @propiedad.dormitorios, estacionamientos: @propiedad.estacionamientos, metros_construidos: @propiedad.metros_construidos, metros_terreno: @propiedad.metros_terreno, piso: @propiedad.piso, precio: @propiedad.precio, tipo_inmueble: @propiedad.tipo_inmueble, tipo_transaccion: @propiedad.tipo_transaccion, titulo: @propiedad.titulo } }
    end

    assert_redirected_to propiedad_url(Propiedad.last)
  end

  test "should show propiedad" do
    get propiedad_url(@propiedad)
    assert_response :success
  end

  test "should get edit" do
    get edit_propiedad_url(@propiedad)
    assert_response :success
  end

  test "should update propiedad" do
    patch propiedad_url(@propiedad), params: { propiedad: { banos: @propiedad.banos, comuna_id: @propiedad.comuna_id, descripcion: @propiedad.descripcion, dormitorios: @propiedad.dormitorios, estacionamientos: @propiedad.estacionamientos, metros_construidos: @propiedad.metros_construidos, metros_terreno: @propiedad.metros_terreno, piso: @propiedad.piso, precio: @propiedad.precio, tipo_inmueble: @propiedad.tipo_inmueble, tipo_transaccion: @propiedad.tipo_transaccion, titulo: @propiedad.titulo } }
    assert_redirected_to propiedad_url(@propiedad)
  end

  test "should destroy propiedad" do
    assert_difference("Propiedad.count", -1) do
      delete propiedad_url(@propiedad)
    end

    assert_redirected_to propiedades_url
  end
  test "catalog filters by commune type and maximum price" do
    @propiedad.update!(titulo: "Casa del catálogo", tipo_inmueble: 0, precio: 100)
    propiedades(:two).update!(titulo: "Departamento excluido", precio: 300)
    get propiedades_url, params: { comuna_id: @propiedad.comuna_id, tipo_inmueble: 0, precio_max: 150 }
    assert_response :success
    assert_select ".property-title", text: "Casa del catálogo", count: 1
    assert_select ".property-title", text: "Departamento excluido", count: 0
    assert_select ".property-price", text: /\$100/
  end

  test "catalog sorts by date regardless of old price ordering and handles empty results" do
    @propiedad.update!(titulo: "Más cara", precio: 200, created_at: 1.day.ago)
    propiedades(:two).update!(titulo: "Más barata", precio: 100, created_at: 2.days.ago)
    get propiedades_url, params: { orden: "precio_asc" }
    assert_response :success
    assert_select ".property-title a" do |links|
      assert_equal ["Más cara", "Más barata"], links.map(&:text)
    end
    get propiedades_url, params: { precio_max: 0 }
    assert_select "h2", text: "No encontramos propiedades"
    assert_select ".property-entry", count: 0
  end

  test "public detail shows data and a reference image without editing controls" do
    sign_out users(:one)
    get propiedad_url(@propiedad)
    assert_response :success
    assert_select "h1", text: @propiedad.titulo
    assert_select ".vian-detail-image"
    assert_select ".vian-feature", text: @propiedad.caracteristicas.first.nombre
    assert_select "a[href=?]", edit_propiedad_path(@propiedad), count: 0
  end

  test "form includes enum options and preserves saved values" do
    @propiedad.update!(tipo_inmueble: :local_comercial, tipo_transaccion: :arriendo, destacada: true)
    get edit_propiedad_url(@propiedad)
    assert_response :success
    Propiedad.tipo_inmuebles.each_key do |tipo|
      assert_select "select[name='propiedad[tipo_inmueble]'] option[value=?]", tipo
    end
    assert_select "option[value=local_comercial][selected]"
    assert_select "select[name='propiedad[tipo_transaccion]'] option[value=arriendo][selected]"
    assert_select "input[name='propiedad[destacada]'][type=checkbox][checked]"
    assert_select "input[name='propiedad[publicada]'][type=checkbox][checked]"
  end

  test "creates and updates the new property fields" do
    assert_difference("Propiedad.count", 1) do
      post propiedades_url, params: { propiedad: {
        titulo: "Oficina de prueba", precio: 500_000, comuna_id: @propiedad.comuna_id,
        tipo_inmueble: "oficina", tipo_transaccion: "arriendo", destacada: "1", publicada: "1"
      } }
    end
    propiedad = Propiedad.order(:id).last
    assert_redirected_to propiedad_url(propiedad)
    assert propiedad.oficina?
    assert propiedad.arriendo?
    assert propiedad.destacada?
    assert propiedad.publicada?

    patch propiedad_url(propiedad), params: { propiedad: {
      tipo_inmueble: "bodega", tipo_transaccion: "venta", destacada: "0", publicada: "0"
    } }
    assert_redirected_to propiedad_url(propiedad)
    propiedad.reload
    assert propiedad.bodega?
    assert propiedad.venta?
    assert_not propiedad.destacada?
    assert_not propiedad.publicada?
  end

  test "catalog puts featured properties first and sorts each group newest first" do
    @propiedad.update!(destacada: true, created_at: 10.days.ago)
    propiedades(:two).update!(destacada: false, created_at: 1.day.ago)
    newer_featured = Propiedad.create!(
      titulo: "Destacada reciente", precio: 100, comuna: comunas(:one),
      tipo_inmueble: :casa, tipo_transaccion: :venta,
      destacada: true, publicada: true, created_at: 5.days.ago
    )
    older_normal = Propiedad.create!(
      titulo: "Normal antigua", precio: 100, comuna: comunas(:one),
      tipo_inmueble: :casa, tipo_transaccion: :venta,
      destacada: false, publicada: true, created_at: 20.days.ago
    )

    get propiedades_url
    assert_response :success
    assert_select "#propiedades .property-title a" do |links|
      expected = [newer_featured, @propiedad, propiedades(:two), older_normal]
      assert_equal expected.map { |property| propiedad_path(property) }, links.map { |link| link["href"] }
    end
    assert_select "select[name=orden]", count: 0
  end

  test "catalog filters sales rentals and all transactions and retains selection" do
    @propiedad.update!(tipo_transaccion: :venta)
    rental = propiedades(:two)
    rental.update!(tipo_transaccion: :arriendo)

    { "venta" => @propiedad, "arriendo" => rental }.each do |transaction, property|
      get propiedades_url, params: { tipo_transaccion: transaction }
      assert_response :success
      assert_select ".property-title a" do |links|
        assert_equal [propiedad_path(property)], links.map { |link| link["href"] }
      end
      assert_select "select[name=tipo_transaccion] option[value=?][selected]", transaction
    end

    ["", "invalida"].each do |transaction|
      get propiedades_url, params: { tipo_transaccion: transaction }
      assert_response :success
      assert_select ".property-entry", count: 2
    end
  end

  test "transaction filter combines with commune type and price filters" do
    @propiedad.update!(tipo_transaccion: :arriendo, tipo_inmueble: :casa, precio: 100)
    propiedades(:two).update!(tipo_transaccion: :arriendo, precio: 300)
    get propiedades_url, params: {
      tipo_transaccion: "arriendo", comuna_id: @propiedad.comuna_id,
      tipo_inmueble: "casa", precio_max: 150
    }
    assert_response :success
    assert_select ".property-title a" do |links|
      assert_equal [propiedad_path(@propiedad)], links.map { |link| link["href"] }
    end
  end

  test "creates property with main image and multiple gallery images" do
    get new_propiedad_url
    assert_select "form[enctype='multipart/form-data']" do
      assert_select "input[type=file][name='propiedad[imagen_principal]']:not([multiple])"
      assert_select "input[type=file][name='propiedad[imagenes][]'][multiple]"
    end

    post propiedades_url, params: { propiedad: {
      titulo: "Propiedad con fotos", precio: 100, comuna_id: @propiedad.comuna_id,
      tipo_inmueble: "casa", tipo_transaccion: "venta",
      imagen_principal: uploaded_property_image, imagenes: [uploaded_property_image, uploaded_property_image]
    } }
    property = Propiedad.order(:id).last
    assert_redirected_to propiedad_url(property)
    assert property.imagen_principal.attached?
    assert_equal 2, property.imagenes.count
  end

  test "editing keeps attachments when empty and appends gallery uploads" do
    @propiedad.imagen_principal.attach(uploaded_property_image)
    @propiedad.imagenes.attach(uploaded_property_image)
    original_main = @propiedad.imagen_principal.blob_id
    original_gallery = @propiedad.imagenes.blobs.ids

    patch propiedad_url(@propiedad), params: { propiedad: { titulo: "Título actualizado", imagen_principal: "", imagenes: [""] } }
    assert_redirected_to propiedad_url(@propiedad)
    @propiedad.reload
    assert_equal original_main, @propiedad.imagen_principal.blob_id
    assert_equal original_gallery, @propiedad.imagenes.blobs.ids

    patch propiedad_url(@propiedad), params: { propiedad: {
      imagen_principal: uploaded_property_image, imagenes: ["", uploaded_property_image]
    } }
    assert_redirected_to propiedad_url(@propiedad)
    @propiedad.reload
    assert_not_equal original_main, @propiedad.imagen_principal.blob_id
    assert_equal 2, @propiedad.imagenes.count
    assert_includes @propiedad.imagenes.blobs.ids, original_gallery.first
  end

  test "property characteristics can be selected on create and cleared on edit" do
    ids = Caracteristica.ids
    post propiedades_url, params: { propiedad: {
      titulo: "Casa equipada", precio: 100, comuna_id: comunas(:one).id,
      tipo_inmueble: "casa", tipo_transaccion: "venta", caracteristica_ids: [""] + ids.map(&:to_s)
    } }
    property = Propiedad.order(:id).last
    assert_redirected_to propiedad_url(property)
    assert_equal ids.sort, property.caracteristica_ids.sort

    get edit_propiedad_url(property)
    assert_response :success
    ids.each do |id|
      assert_select "input[type=checkbox][name='propiedad[caracteristica_ids][]'][value=?][checked]", id.to_s
    end

    patch propiedad_url(property), params: { propiedad: { caracteristica_ids: ["", ids.first.to_s] } }
    assert_redirected_to propiedad_url(property)
    assert_equal [ids.first], property.reload.caracteristica_ids

    patch propiedad_url(property), params: { propiedad: { caracteristica_ids: [""] } }
    assert_redirected_to propiedad_url(property)
    assert_empty property.reload.caracteristicas
  end

  test "video URL is saved displayed updated and cleared" do
    url = "https://www.youtube.com/watch?v=aqz-KE-bpKQ"
    post propiedades_url, params: { propiedad: {
      titulo: "Casa con video", precio: 100, comuna_id: comunas(:one).id,
      tipo_inmueble: "casa", tipo_transaccion: "venta", video_url: url
    } }
    property = Propiedad.order(:id).last
    assert_redirected_to propiedad_url(property)
    assert_equal url, property.video_url

    get edit_propiedad_url(property)
    assert_response :success
    assert_select "input[type=url][name='propiedad[video_url]'][value=?]", url

    replacement = "https://youtu.be/aqz-KE-bpKQ"
    patch propiedad_url(property), params: { propiedad: { video_url: replacement } }
    assert_redirected_to propiedad_url(property)
    assert_equal replacement, property.reload.video_url

    patch propiedad_url(property), params: { propiedad: { video_url: "" } }
    assert_redirected_to propiedad_url(property)
    assert property.reload.video_url.blank?
  end

  test "detail embeds YouTube video only for valid video URLs" do
    ["https://www.youtube.com/watch?v=aqz-KE-bpKQ", "https://youtu.be/aqz-KE-bpKQ"].each do |url|
      @propiedad.update_column(:video_url, url)
      get propiedad_url(@propiedad)
      assert_response :success
      assert_select "aside iframe[src='https://www.youtube-nocookie.com/embed/aqz-KE-bpKQ']", count: 1
    end

    [nil, "", "https://example.com/watch?v=aqz-KE-bpKQ", "not a URL"].each do |url|
      @propiedad.update_column(:video_url, url)
      get propiedad_url(@propiedad)
      assert_response :success
      assert_select "iframe.vian-property-video", count: 0
    end
  end

  private

  def uploaded_property_image
    Rack::Test::UploadedFile.new(Rails.root.join("app/assets/images/img_1.jpg"), "image/jpeg")
  end

end
