module ApplicationHelper
  WHATSAPP_PHONE = "56994798433"

  def whatsapp_url(message)
    "https://wa.me/#{WHATSAPP_PHONE}?#{URI.encode_www_form(text: message)}"
  end

  def general_whatsapp_url
    whatsapp_url("Hola, me interesó una de sus propiedades y me gustaría que me contacten.")
  end
end
