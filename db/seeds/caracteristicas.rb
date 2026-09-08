# db/seeds.rb

caracteristicas = [
  { clave: "piscina", nombre: "Piscina" },
  { clave: "quincho", nombre: "Quincho" },
  { clave: "terraza", nombre: "Terraza" },
  { clave: "jardin", nombre: "Jardín" },
  { clave: "bodega", nombre: "Bodega" },
  { clave: "logia", nombre: "Logia" },
  { clave: "balcon", nombre: "Balcón" },
  { clave: "patio", nombre: "Patio" },
  { clave: "estacionamiento_visitas", nombre: "Estacionamiento de Visitas" },
  { clave: "conserjeria", nombre: "Conserjería 24 Horas" },
  { clave: "ascensor", nombre: "Ascensor" },
  { clave: "gimnasio", nombre: "Gimnasio" },
  { clave: "sala_eventos", nombre: "Sala de Eventos" },
  { clave: "juegos_infantiles", nombre: "Juegos Infantiles" },
  { clave: "porton_electrico", nombre: "Portón Eléctrico" },
  { clave: "aire_acondicionado", nombre: "Aire Acondicionado" },
  { clave: "calefaccion", nombre: "Calefacción" },
  { clave: "amoblado", nombre: "Amoblado" },
  { clave: "vista_mar", nombre: "Vista al Mar" },
  { clave: "vista_panoramica", nombre: "Vista Panorámica" }
]

caracteristicas.each do |caracteristica|
  Caracteristica.find_or_create_by!(clave: caracteristica[:clave]) do |c|
    c.nombre = caracteristica[:nombre]
  end
end