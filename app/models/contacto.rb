class Contacto < MailForm::Base
  attribute :nombre
  attribute :email
  attribute :asunto
  attribute :mensaje
  attribute :website, captcha: true

  validates :nombre, :asunto, :mensaje, presence: { message: "no puede estar vacío" }
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "debe ser un correo válido" }
  validates :nombre, :asunto, length: { maximum: 200, message: "es demasiado largo" }
  validates :mensaje, length: { maximum: 10000, message: "es demasiado largo" }

  def headers
    {
      to: "vianpropiedades@gmail.com",
      from: ENV.fetch("SMTP_USERNAME", "vianpropiedades@gmail.com"),
      reply_to: email,
      subject: "Contacto web Vian Propiedades"
    }
  end
end
