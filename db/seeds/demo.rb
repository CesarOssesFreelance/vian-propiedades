# Cuentas ficticias para desarrollo y pruebas; no se restablecen contraseñas existentes.
[
  { email: "admin@vian.example", nombre: "Camila", apellido_paterno: "Soto",
    apellido_materno: "Rojas", rut: "11111111-1", role: :admin },
  { email: "corredor@vian.example", nombre: "Diego", apellido_paterno: "Muñoz",
    apellido_materno: "Pérez", rut: "22222222-2", role: :corredor }
].each do |atributos|
  User.find_or_create_by!(email: atributos.fetch(:email)) do |user|
    user.assign_attributes(atributos)
    user.password = ENV.fetch("SEED_USER_PASSWORD", "VianDemo2026!")
    user.password_confirmation = user.password
  end
end

# Video genérico de demostración (Big Buck Bunny), no corresponde a las propiedades.
video_demo = "https://www.youtube.com/watch?v=aqz-KE-bpKQ"

# Precios ficticios en CLP y superficies en m².
region = Region.find_by!(nombre: "Región Metropolitana de Santiago")
caracteristicas = Caracteristica.all.index_by(&:clave)

# Título, comuna, tipo de inmueble, transacción, destacada, publicada,
# precio (total en venta o mensual en arriendo), dormitorios, baños, estacionamientos,
# superficie construida, terreno, piso, características, URL del video.
[
  [ "Casa familiar con jardín", "La Florida", :casa, :venta, true, true, 185_000_000, 3, 2, 2, 110, 220, nil, %w[jardin patio quincho], video_demo ],
  [ "Departamento luminoso", "Ñuñoa", :departamento, :venta, false, true, 145_000_000, 2, 2, 1, 65, 0, 5, %w[balcon ascensor conserjeria], video_demo ],
  [ "Casa con piscina", "Las Condes", :casa, :venta, true, true, 420_000_000, 4, 3, 3, 200, 450, nil, %w[piscina jardin terraza], video_demo ],
  [ "Departamento con terraza", "Providencia", :departamento, :arriendo, true, true, 950_000, 3, 2, 1, 90, 0, 8, %w[terraza bodega ascensor], video_demo ],
  [ "Casa con patio", "Maipú", :casa, :venta, false, true, 125_000_000, 3, 2, 1, 85, 150, nil, %w[patio porton_electrico], video_demo ],
  [ "Departamento amoblado", "Santiago", :departamento, :arriendo, false, true, 380_000, 1, 1, 0, 35, 0, 12, %w[amoblado gimnasio conserjeria], nil ],
  [ "Casa amplia", "La Reina", :casa, :venta, false, true, 310_000_000, 4, 3, 2, 160, 320, nil, %w[jardin quincho calefaccion], nil ],
  [ "Departamento con vista", "San Miguel", :departamento, :arriendo, false, true, 520_000, 2, 2, 1, 58, 0, 15, %w[vista_panoramica balcon piscina], nil ],
  [ "Casa con quincho", "Peñalolén", :casa, :venta, false, true, 245_000_000, 3, 3, 2, 130, 260, nil, %w[quincho jardin bodega], nil ],
  [ "Departamento familiar", "Macul", :departamento, :venta, false, false, 132_000_000, 3, 2, 1, 72, 0, 6, %w[logia juegos_infantiles estacionamiento_visitas], nil ]
].each do |titulo, comuna_nombre, tipo, transaccion, destacada, publicada, precio, dormitorios, banos, estacionamientos, construidos, terreno, piso, claves, video_url|
  comuna = region.comunas.find_by!(nombre: comuna_nombre)
  propiedad = Propiedad.find_or_create_by!(titulo: titulo, comuna: comuna) do |registro|
    registro.assign_attributes(
      descripcion: "#{titulo} en #{comuna_nombre}, con #{dormitorios} dormitorios, #{banos} baños y #{construidos} m² construidos. Propiedad ficticia para demostración.",
      tipo_inmueble: tipo, tipo_transaccion: transaccion,
      destacada: destacada, publicada: publicada,
      precio: precio, dormitorios: dormitorios, banos: banos,
      estacionamientos: estacionamientos, metros_construidos: construidos,
      metros_terreno: terreno, piso: piso, video_url: video_url
    )
  end

  claves.each do |clave|
    propiedad.propiedad_caracteristicas.find_or_create_by!(caracteristica: caracteristicas.fetch(clave))
  end
end

puts "Seed demo completado: 10 propiedades y usuarios admin@vian.example y corredor@vian.example."
