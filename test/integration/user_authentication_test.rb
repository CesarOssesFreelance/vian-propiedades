require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "login renders without a public signup link" do
    get new_user_session_path
    assert_response :success
    assert_select ".vian-auth .vian-auth-card form" do
      assert_select "input.form-control[type=email]"
      assert_select "input.form-control[type=password]"
    end

    assert_select "a", text: "Crear una cuenta", count: 0
  end

  test "public signup routes do not exist" do
    assert_raises(ActionController::RoutingError) do
      Rails.application.routes.recognize_path("/users/sign_up", method: :get)
    end
  end

  test "password recovery email uses the Vian Gmail sender" do
    assert_emails 1 do
      users(:one).send_reset_password_instructions
    end

    assert_equal [ "vianpropiedades@gmail.com" ], ActionMailer::Base.deliveries.last.from
  end
end
