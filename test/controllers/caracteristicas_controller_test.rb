require "test_helper"

class CaracteristicasControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:one)
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
      post caracteristicas_url, params: { caracteristica: { clave: "nueva_clave", nombre: "Nueva característica" } }
    end

    assert_redirected_to caracteristicas_url
  end

  test "should get edit" do
    get edit_caracteristica_url(@caracteristica)
    assert_response :success
  end

  test "should update caracteristica" do
    patch caracteristica_url(@caracteristica), params: { caracteristica: { clave: "nueva_clave", nombre: "Nueva característica" } }
    assert_redirected_to caracteristicas_url
  end

  test "should destroy caracteristica" do
    assert_difference("Caracteristica.count", -1) do
      delete caracteristica_url(@caracteristica)
    end

    assert_redirected_to caracteristicas_url
  end
end
