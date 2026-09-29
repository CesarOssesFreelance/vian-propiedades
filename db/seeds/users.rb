usuarios = [
  {
    email: ENV.fetch("SEED_SUPER_ADMIN_EMAIL", "cesar.osses@gmail.com"),
    password: ENV.fetch("SEED_SUPER_ADMIN_PASSWORD", "VianDemo2026!"),
    nombre: "César",
    apellido_paterno: "Osses",
    rut: "76000000-1",
    role: :super_admin
  },
  {
    email: ENV.fetch("SEED_ADMIN_EMAIL", "vianpropiedades@gmail.com"),
    password: ENV.fetch("SEED_ADMIN_PASSWORD", "VianDemo2026!"),
    nombre: "Verena",
    apellido_paterno: "Lauer",
    rut: "76000001-K",
    role: :admin
  }
]

usuarios.each do |atributos|
  password = atributos.delete(:password)
  user = User.find_or_initialize_by(email: atributos.fetch(:email))
  user.assign_attributes(atributos)
  if user.new_record?
    user.password = password
    user.password_confirmation = password
  end
  user.save!
end

puts "Usuarios base creados: superadmin y admin."
