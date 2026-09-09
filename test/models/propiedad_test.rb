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
end
