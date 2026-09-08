class Comuna < ApplicationRecord
  belongs_to :region
  has_many :propiedades, dependent: :restrict_with_error
end
