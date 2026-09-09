require "test_helper"

class ContactoTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "valid contact sends to Vian with visitor reply address" do
    assert_emails 1 do
      post contacto_path, params: { contacto: { nombre: "Ana", email: "ana@example.com", asunto: "Consulta", mensaje: "Busco una casa" } }
    end
    assert_redirected_to root_path(anchor: "contacto")
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["vianpropiedades@gmail.com"], mail.to
    assert_equal ["ana@example.com"], mail.reply_to
  end

  test "invalid contact preserves input without sending" do
    assert_no_emails do
      post contacto_path, params: { contacto: { nombre: "Ana", email: "invalid", asunto: "Consulta", mensaje: "" } }
    end
    assert_response :unprocessable_entity
    assert_select "input[name='contacto[nombre]'][value=Ana]"
    assert_select ".vian-contact-form .alert-danger"
  end

  test "honeypot prevents sending" do
    assert_no_emails do
      post contacto_path, params: { contacto: { website: "spam" } }
    end
    assert_response :redirect
  end
end
