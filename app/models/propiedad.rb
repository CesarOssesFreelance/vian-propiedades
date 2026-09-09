class Propiedad < ApplicationRecord
  extend FriendlyId
  friendly_id :titulo, use: :slugged

  belongs_to :comuna
  has_many :propiedad_caracteristicas, dependent: :destroy
  has_many :caracteristicas, through: :propiedad_caracteristicas
  has_one_attached :imagen_principal
  has_many_attached :imagenes

  enum :tipo_inmueble, {
    casa: 0,
    departamento: 1,
    parcela: 2,
    terreno: 3,
    oficina: 4,
    local_comercial: 5,
    bodega: 6,
    otro: 7
  }

  enum :tipo_transaccion, {
    venta: 0,
    arriendo: 1
  }

   validates :video_url,
            format: {
              with: /\Ahttps?:\/\/(www\.)?(youtube\.com|youtu\.be)\//i,
              message: "debe ser una URL válida de YouTube"
            },
            allow_blank: true
end
