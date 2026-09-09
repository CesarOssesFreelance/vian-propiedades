class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  


  enum :role, {
    admin: 0,
    corredor: 1
  }

  before_validation :normalize_rut

  validates :nombre, presence: true
  validates :apellido_paterno, presence: true
  validates :rut, presence: true, uniqueness: true
  validates :role, presence: true

  private

  def normalize_rut
    return if rut.blank?

    cleaned = rut.to_s
                 .upcase
                 .gsub(".", "")
                 .gsub(/\s+/, "")
                 .gsub("-", "")

    return if cleaned.length < 2

    self.rut = "#{cleaned[0...-1]}-#{cleaned[-1]}"
  end
end
