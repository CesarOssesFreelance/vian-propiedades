class Propiedad < ApplicationRecord
  belongs_to :comuna
  has_many :propiedad_caracteristicas, dependent: :destroy
  has_many :caracteristicas, through: :propiedad_caracteristicas
  has_many_attached :imagenes
end
