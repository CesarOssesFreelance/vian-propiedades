require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  test "login and signup render the template forms" do
    get new_user_session_path
    assert_response :success
    assert_select ".vian-auth .vian-auth-card form" do
      assert_select "input.form-control[type=email]"
      assert_select "input.form-control[type=password]"
    end

    get new_user_registration_path
    assert_response :success
    assert_select ".vian-auth input[name='user[rut]']"
    assert_select "input[name='user[role]']", count: 0
  end

  test "signup accepts personal details and assigns corredor even if admin is requested" do
    assert_difference("User.count", 1) do
      post user_registration_path, params: { user: {
        nombre: "Ana", apellido_paterno: "Pérez", apellido_materno: "Soto",
        rut: "12.345.678-5", email: "signup@example.com",
        password: "password123", password_confirmation: "password123", role: "admin"
      } }
    end
    assert_response :redirect
    user = User.find_by!(email: "signup@example.com")
    assert user.corredor?
    assert_equal "12345678-5", user.rut
    assert_equal "Ana", user.nombre
  end

  test "invalid signup displays errors within the styled form" do
    post user_registration_path, params: { user: {
      email: "invalid@example.com", password: "password123", password_confirmation: "different"
    } }
    assert_response :unprocessable_entity
    assert_select ".vian-auth-card .alert-danger li"
  end
end
