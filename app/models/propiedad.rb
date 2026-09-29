class Propiedad < ApplicationRecord
  extend FriendlyId
  friendly_id :titulo, use: :slugged

  belongs_to :comuna
  has_many :propiedad_caracteristicas, dependent: :destroy
  has_many :caracteristicas, through: :propiedad_caracteristicas
  IMAGE_VARIANTS = {
    card: { resize_to_fill: [720, 470], format: :webp, saver: { quality: 80, strip: true } },
    hero: { resize_to_fill: [1920, 1080], format: :webp, saver: { quality: 80, strip: true } },
    gallery: { resize_to_limit: [1600, 1200], format: :webp, saver: { quality: 82, strip: true } },
    thumbnail: { resize_to_fill: [240, 180], format: :webp, saver: { quality: 72, strip: true } },
    social: { resize_to_fill: [1200, 630], format: :jpg, saver: { quality: 84, strip: true } }
  }.freeze

  has_one_attached :imagen_principal do |attachable|
    IMAGE_VARIANTS.each { |name, transformations| attachable.variant(name, transformations) }
  end
  has_many_attached :imagenes do |attachable|
    IMAGE_VARIANTS.each { |name, transformations| attachable.variant(name, transformations) }
  end

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
