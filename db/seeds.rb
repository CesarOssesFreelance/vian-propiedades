# Carga repetible, sin borrar registros existentes: bin/rails db:seed.
ActiveRecord::Base.transaction do
  load Rails.root.join("db/seeds/regiones_comunas.rb")
  load Rails.root.join("db/seeds/caracteristicas.rb")

  if Rails.env.development? || Rails.env.test?
    load Rails.root.join("db/seeds/demo.rb")
  end
end
