class SeoController < ApplicationController
  def sitemap
    @propiedades = Propiedad.where(publicada: true).includes(comuna: :region)
                            .preload(imagen_principal_attachment: :blob, imagenes_attachments: :blob)
                            .order(updated_at: :desc)
  end
end
