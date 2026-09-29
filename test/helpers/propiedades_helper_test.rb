require "test_helper"

class PropiedadesHelperTest < ActionView::TestCase
  test "uses the main image instead of the first gallery image" do
    property = propiedades(:one)
    property.imagen_principal.attach(
      io: File.open(Rails.root.join("app/assets/images/img_1.jpg")),
      filename: "principal.jpg",
      content_type: "image/jpeg"
    )
    property.imagenes.attach(
      io: File.open(Rails.root.join("app/assets/images/img_2.jpg")),
      filename: "galeria.jpg",
      content_type: "image/jpeg"
    )

    assert_equal property.imagen_principal.attachment, imagen_propiedad(property)
    assert_not_equal property.imagenes.first, imagen_propiedad(property)
  end

  test "uses a reference image when the property has no main image" do
    property = propiedades(:one)
    property.imagen_principal.purge if property.imagen_principal.attached?

    assert_equal "img_#{(property.id % 8) + 1}.jpg", imagen_propiedad(property)
  end
end
