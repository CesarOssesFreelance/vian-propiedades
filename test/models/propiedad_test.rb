require "test_helper"

class PropiedadTest < ActiveSupport::TestCase
  test "generates readable unique slugs and keeps them when title changes" do
    attributes = { titulo: "Casa en Ñuñoa", precio: 100, comuna: comunas(:one),
                   tipo_inmueble: :casa, tipo_transaccion: :venta }
    property = Propiedad.create!(attributes)
    duplicate = Propiedad.create!(attributes)

    assert_equal "casa-en-nunoa", property.slug
    assert_equal property.slug, property.to_param
    assert_not_equal property.slug, duplicate.slug
    assert_equal property, Propiedad.friendly.find(property.slug)
    assert_equal property, Propiedad.friendly.find(property.id)

    property.update!(titulo: "Casa renovada")
    assert_equal "casa-en-nunoa", property.slug
  end
  test "generates named WebP variants with Vips" do
    property = propiedades(:one)
    property.imagen_principal.attach(
      io: File.open(Rails.root.join("app/assets/images/img_1.jpg")),
      filename: "source.jpg",
      content_type: "image/jpeg"
    )

    variant = property.imagen_principal.variant(:card).processed
    output = Vips::Image.new_from_buffer(variant.download, "")

    assert_equal "image/webp", variant.image.content_type
    assert_equal 720, output.width
    assert_equal 470, output.height
    assert_operator variant.image.byte_size, :<, property.imagen_principal.blob.byte_size
  end

end
