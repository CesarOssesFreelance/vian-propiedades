class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("SMTP_USERNAME", "vianpropiedades@gmail.com")
  layout "mailer"
end
