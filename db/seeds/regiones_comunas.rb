puts "Limpiando datos..."

Comuna.destroy_all
Region.destroy_all

puts "Creando regiones y comunas de Chile..."

regiones = {
  "Región de Arica y Parinacota" => [
    "Arica",
    "Camarones",
    "Putre",
    "General Lagos"
  ],

  "Región de Tarapacá" => [
    "Iquique",
    "Alto Hospicio",
    "Pozo Almonte",
    "Camiña",
    "Colchane",
    "Huara",
    "Pica"
  ],

  "Región de Antofagasta" => [
    "Antofagasta",
    "Mejillones",
    "Sierra Gorda",
    "Taltal",
    "Calama",
    "Ollagüe",
    "San Pedro de Atacama",
    "María Elena",
    "Tocopilla"
  ],

  "Región de Atacama" => [
    "Copiapó",
    "Caldera",
    "Tierra Amarilla",
    "Chañaral",
    "Diego de Almagro",
    "Vallenar",
    "Alto del Carmen",
    "Freirina",
    "Huasco"
  ],

  "Región de Coquimbo" => [
    "La Serena",
    "Coquimbo",
    "Andacollo",
    "La Higuera",
    "Paihuano",
    "Vicuña",
    "Illapel",
    "Canela",
    "Los Vilos",
    "Salamanca",
    "Ovalle",
    "Combarbalá",
    "Monte Patria",
    "Punitaqui",
    "Río Hurtado"
  ],

  "Región de Valparaíso" => [
    "Valparaíso",
    "Viña del Mar",
    "Concón",
    "Quilpué",
    "Villa Alemana",
    "Casablanca",
    "Quillota",
    "La Calera",
    "La Cruz",
    "Hijuelas",
    "Limache",
    "Olmué",
    "San Antonio",
    "Cartagena",
    "El Quisco",
    "El Tabo",
    "Algarrobo",
    "Quintero",
    "Puchuncaví",
    "Llaillay",
    "Nogales",
    "Calera de Tango"
  ],

  "Región Metropolitana de Santiago" => [
    "Santiago",
    "Cerrillos",
    "Cerro Navia",
    "Conchalí",
    "El Bosque",
    "Estación Central",
    "Huechuraba",
    "Independencia",
    "La Cisterna",
    "La Florida",
    "La Granja",
    "La Pintana",
    "La Reina",
    "Las Condes",
    "Lo Barnechea",
    "Lo Espejo",
    "Lo Prado",
    "Macul",
    "Maipú",
    "Ñuñoa",
    "Pedro Aguirre Cerda",
    "Peñalolén",
    "Providencia",
    "Pudahuel",
    "Quilicura",
    "Quinta Normal",
    "Recoleta",
    "Renca",
    "San Joaquín",
    "San Miguel",
    "San Ramón",
    "Vitacura",
    "Puente Alto",
    "Pirque",
    "San José de Maipo",
    "Colina",
    "Lampa",
    "Tiltil",
    "Buin",
    "Calera de Tango",
    "Paine",
    "San Bernardo",
    "Melipilla",
    "María Pinto",
    "Curacaví",
    "Talagante",
    "El Monte",
    "Isla de Maipo",
    "Padre Hurtado",
    "Peñaflor"
  ],

  "Región del Libertador General Bernardo O'Higgins" => [
    "Rancagua",
    "Machalí",
    "Graneros",
    "Codegua",
    "Coinco",
    "Coltauco",
    "Doñihue",
    "Las Cabras",
    "Litueche",
    "Malloa",
    "Mostazal",
    "Olivar",
    "Peumo",
    "Pichidegua",
    "Quinta de Tilcoco",
    "Rengo",
    "Requínoa",
    "San Vicente",
    "Pichilemu"
  ],

  "Región del Maule" => [
    "Talca",
    "Linares",
    "Curicó",
    "Constitución",
    "Cauquenes",
    "Maule",
    "San Clemente",
    "San Javier",
    "Parral",
    "Villa Alegre",
    "Romeral",
    "Teno",
    "Rauco",
    "Hualañé",
    "Licantén",
    "Vichuquén",
    "Colbún",
    "Longaví"
  ],

  "Región de Ñuble" => [
    "Chillán",
    "Chillán Viejo",
    "San Carlos",
    "Coihueco",
    "Quillón",
    "Bulnes",
    "Pinto",
    "Yungay",
    "El Carmen",
    "Pemuco",
    "San Ignacio",
    "Ñiquén",
    "Cobquecura",
    "Quirihue",
    "Ninhue",
    "Portezuelo",
    "Ránquil",
    "Trehuaco"
  ],

  "Región del Biobío" => [
    "Concepción",
    "Talcahuano",
    "Hualpén",
    "San Pedro de la Paz",
    "Chiguayante",
    "Coronel",
    "Lota",
    "Penco",
    "Tomé",
    "Florida",
    "Hualqui",
    "Lebu",
    "Arauco",
    "Cañete",
    "Los Ángeles",
    "Nacimiento",
    "Mulchén",
    "Quilaco",
    "Yumbel",
    "Santa Bárbara"
  ],

  "Región de La Araucanía" => [
    "Temuco",
    "Padre Las Casas",
    "Villarrica",
    "Pucón",
    "Angol",
    "Victoria",
    "Lautaro",
    "Nueva Imperial",
    "Carahue",
    "Pitrufquén",
    "Freire",
    "Gorbea",
    "Loncoche",
    "Collipulli"
  ],

  "Región de Los Ríos" => [
    "Valdivia",
    "La Unión",
    "Río Bueno",
    "Paillaco",
    "Panguipulli",
    "Los Lagos",
    "Lanco",
    "Futrono"
  ],

  "Región de Los Lagos" => [
    "Puerto Montt",
    "Puerto Varas",
    "Osorno",
    "Castro",
    "Ancud",
    "Quellón",
    "Puerto Octay",
    "Frutillar",
    "Llanquihue",
    "Calbuco",
    "Maullín",
    "Chaitén",
    "Futaleufú",
    "Palena"
  ],

  "Región de Aysén del General Carlos Ibáñez del Campo" => [
    "Coyhaique",
    "Puerto Aysén",
    "Chile Chico",
    "Cochrane",
    "Lago Verde",
    "Guaitecas"
  ],

  "Región de Magallanes y de la Antártica Chilena" => [
    "Punta Arenas",
    "Puerto Natales",
    "Porvenir",
    "Cabo de Hornos",
    "Primavera",
    "Timaukel",
    "Río Verde"
  ]
}

regiones.each do |region_nombre, comunas|
  region = Region.create!(nombre: region_nombre)

  comunas.each do |comuna_nombre|
    Comuna.create!(
      nombre: comuna_nombre,
      region: region
    )
  end
end

puts "Seed de Chile completado 🚀"