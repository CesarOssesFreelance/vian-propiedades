require "test_helper"

class CaracteristicasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @caracteristica = caracteristicas(:one)
  end

  test "should get index" do
    get caracteristicas_url
    assert_response :success
  end

  test "should get new" do
    get new_caracteristica_url
    assert_response :success
  end

  test "should create caracteristica" do
    assert_difference("Caracteristica.count") do
      post caracteristicas_url, params: { caracteristica: { clave: @caracteristica.clave, nombre: @caracteristica.nombre } }
    end

    assert_redirected_to caracteristica_url(Caracteristica.last)
  end

  test "should show caracteristica" do
    get caracteristica_url(@caracteristica)
    assert_response :success
  end

  test "should get edit" do
    get edit_caracteristica_url(@caracteristica)
    assert_response :success
  end

  test "should update caracteristica" do
    patch caracteristica_url(@caracteristica), params: { caracteristica: { clave: @caracteristica.clave, nombre: @caracteristica.nombre } }
    assert_redirected_to caracteristica_url(@caracteristica)
  end

  test "should destroy caracteristica" do
    assert_difference("Caracteristica.count", -1) do
      delete caracteristica_url(@caracteristica)
    end

    assert_redirected_to caracteristicas_url
  end
end
