require "test_helper"

class CatalogPermissionsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitors cannot access management or mutate records" do
    [new_propiedad_path, edit_propiedad_path(propiedades(:one)), caracteristicas_path,
     new_caracteristica_path, edit_caracteristica_path(caracteristicas(:one))].each do |path|
      get path
      assert_redirected_to new_user_session_path
    end
    assert_no_difference ["Propiedad.count", "Caracteristica.count"] do
      [propiedades_path, caracteristicas_path].each do |path|
        post path, params: {}
        assert_redirected_to new_user_session_path
      end
      [propiedad_path(propiedades(:one)), caracteristica_path(caracteristicas(:one))].each do |path|
        patch path, params: {}
        assert_redirected_to new_user_session_path
        delete path
        assert_redirected_to new_user_session_path
      end
    end
    get propiedades_path
    assert_response :success
    get propiedad_path(propiedades(:one))
    assert_response :success
  end

  test "corredor can create and update both resources but cannot delete in HTML or JSON" do
    sign_in users(:two)
    [new_propiedad_path, edit_propiedad_path(propiedades(:one)), caracteristicas_path,
     new_caracteristica_path, edit_caracteristica_path(caracteristicas(:one))].each do |path|
      get path
      assert_response :success
    end
    assert_select "a[data-turbo-method=delete]", count: 0
    assert_difference "Propiedad.count", 1 do
      post propiedades_path, params: { propiedad: {
        titulo: "Creada por corredor", precio: 100, comuna_id: comunas(:one).id,
        tipo_inmueble: "casa", tipo_transaccion: "venta"
      } }
      assert_response :redirect
    end
    assert_difference "Caracteristica.count", 1 do
      post caracteristicas_path, params: { caracteristica: { nombre: "Nueva", clave: "nueva" } }
      assert_redirected_to caracteristicas_path
    end
    patch propiedad_path(propiedades(:one)), params: { propiedad: { titulo: "Editada" } }
    assert_response :redirect
    assert_equal "Editada", propiedades(:one).reload.titulo
    patch caracteristica_path(caracteristicas(:one)), params: { caracteristica: { nombre: "Editada" } }
    assert_redirected_to caracteristicas_path
    assert_equal "Editada", caracteristicas(:one).reload.nombre

    assert_no_difference ["Propiedad.count", "Caracteristica.count"] do
      [propiedad_path(propiedades(:one)), caracteristica_path(caracteristicas(:one))].each do |path|
        delete path
        assert_response :forbidden
        delete "#{path}.json"
        assert_response :forbidden
      end
    end
    get propiedad_path(propiedades(:one))
    assert_select "a[href=?]", edit_propiedad_path(propiedades(:one)), count: 1
    assert_select "button", text: "Eliminar propiedad", count: 0
  end

  test "user without a recognized role cannot manage catalog" do
    user = users(:two)
    user.update_column(:role, nil)
    sign_in user
    get new_propiedad_path
    assert_response :forbidden
    get caracteristicas_path
    assert_response :forbidden
  end
end
