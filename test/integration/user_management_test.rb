require "test_helper"

class UserManagementTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visitors are redirected and admins are forbidden from user management" do
    get users_path
    assert_redirected_to new_user_session_path

    sign_in users(:two)
    get users_path
    assert_response :forbidden
    assert_no_difference "User.count" do
      post users_path, params: { user: valid_user_attributes }
    end
    assert_response :forbidden
  end

  test "super admin can list create edit roles and delete users" do
    sign_in users(:one)
    get users_path
    assert_response :success
    assert_select "a[href=?]", new_user_path

    assert_difference "User.count", 1 do
      post users_path, params: { user: valid_user_attributes }
    end
    created = User.find_by!(email: "nuevo@vian.example")
    assert created.admin?

    patch user_path(created), params: { user: {
      nombre: created.nombre, apellido_paterno: created.apellido_paterno,
      rut: created.rut, email: created.email, role: "super_admin",
      password: "", password_confirmation: ""
    } }
    assert_redirected_to users_path
    assert created.reload.super_admin?

    assert_difference "User.count", -1 do
      delete user_path(created)
    end
    assert_response :see_other
  end

  test "last super admin cannot be demoted or delete itself" do
    super_admin = users(:one)
    sign_in super_admin

    patch user_path(super_admin), params: { user: {
      nombre: super_admin.nombre, apellido_paterno: super_admin.apellido_paterno,
      rut: super_admin.rut, email: super_admin.email, role: "admin",
      password: "", password_confirmation: ""
    } }
    assert_response :unprocessable_entity
    assert super_admin.reload.super_admin?

    assert_no_difference "User.count" do
      delete user_path(super_admin)
    end
    assert_redirected_to users_path
  end

  private

  def valid_user_attributes
    {
      nombre: "Nuevo", apellido_paterno: "Usuario", rut: "33333333-3",
      email: "nuevo@vian.example", role: "admin",
      password: "password123", password_confirmation: "password123"
    }
  end
end
