class Region < ApplicationRecord
    has_many :comunas, dependent: :restrict_with_error
end
