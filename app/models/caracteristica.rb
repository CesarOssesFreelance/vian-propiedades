class Caracteristica < ApplicationRecord
    has_many :propiedad_caracteristicas, dependent: :destroy

    has_many :propiedades, through: :propiedad_caracteristicas
end
