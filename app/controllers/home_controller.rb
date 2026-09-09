class HomeController < ApplicationController
  def index
    @propiedades_hero = Propiedad.where(publicada: true).preload(imagenes_attachments: :blob)
                                .order(destacada: :desc, created_at: :desc, id: :desc).limit(10)
    @propiedades = Propiedad.where(publicada: true).includes(:comuna).preload(imagenes_attachments: :blob)
                            .order(destacada: :desc, created_at: :desc, id: :desc).limit(9)
    @comunas = Comuna.where(id: Propiedad.select(:comuna_id)).order(:nombre)
  end
  
  def contacto
    @contacto = Contacto.new(params.expect(contacto: [:nombre, :email, :asunto, :mensaje, :website]))
    if @contacto.website.present?
      redirect_to root_path(anchor: "contacto"), notice: "Gracias por contactarnos.", status: :see_other
      return
    end
    if @contacto.deliver
      redirect_to root_path(anchor: "contacto"), notice: "Tu mensaje fue enviado correctamente. Te contactaremos pronto.", status: :see_other
    else
      index
      render :index, status: :unprocessable_entity
    end
  rescue Net::SMTPError, IOError, SystemCallError, Timeout::Error, SocketError, OpenSSL::SSL::SSLError => error
    Rails.logger.error("Contact delivery failed: #{error.class}")
    flash.now[:alert] = "No pudimos enviar tu mensaje. Inténtalo nuevamente más tarde."
    index
    render :index, status: :service_unavailable
  end

end
