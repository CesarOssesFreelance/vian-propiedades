require "test_helper"

class PropiedadesControllerTest < ActionDispatch::IntegrationTest
  setup do
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
      post propiedades_url, params: { propiedad: { banos: @propiedad.banos, comuna_id: @propiedad.comuna_id, descripcion: @propiedad.descripcion, dormitorios: @propiedad.dormitorios, estacionamientos: @propiedad.estacionamientos, metros_construidos: @propiedad.metros_construidos, metros_terreno: @propiedad.metros_terreno, piso: @propiedad.piso, precio: @propiedad.precio, tipo_inmueble: @propiedad.tipo_inmueble, titulo: @propiedad.titulo } }
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
    patch propiedad_url(@propiedad), params: { propiedad: { banos: @propiedad.banos, comuna_id: @propiedad.comuna_id, descripcion: @propiedad.descripcion, dormitorios: @propiedad.dormitorios, estacionamientos: @propiedad.estacionamientos, metros_construidos: @propiedad.metros_construidos, metros_terreno: @propiedad.metros_terreno, piso: @propiedad.piso, precio: @propiedad.precio, tipo_inmueble: @propiedad.tipo_inmueble, titulo: @propiedad.titulo } }
    assert_redirected_to propiedad_url(@propiedad)
  end

  test "should destroy propiedad" do
    assert_difference("Propiedad.count", -1) do
      delete propiedad_url(@propiedad)
    end

    assert_redirected_to propiedades_url
  end
end
