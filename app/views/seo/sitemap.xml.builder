xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset("xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9", "xmlns:image" => "http://www.google.com/schemas/sitemap-image/1.1") do
  xml.url do
    xml.loc root_url(host: "vianpropiedades.cl", protocol: "https")
    xml.changefreq "weekly"
    xml.priority "1.0"
  end
  xml.url do
    xml.loc propiedades_url(host: "vianpropiedades.cl", protocol: "https")
    xml.changefreq "daily"
    xml.priority "0.9"
  end
  @propiedades.each do |propiedad|
    xml.url do
      xml.loc propiedad_url(propiedad, host: "vianpropiedades.cl", protocol: "https")
      xml.lastmod propiedad.updated_at.iso8601
      xml.changefreq "weekly"
      xml.priority propiedad.destacada? ? "0.9" : "0.8"
      images = propiedad.imagenes.to_a
      images.unshift(propiedad.imagen_principal) if propiedad.imagen_principal.attached?
      images.first(20).each do |image|
        xml.tag!("image:image") do
          xml.tag!("image:loc", rails_blob_url(image, host: "vianpropiedades.cl", protocol: "https"))
          xml.tag!("image:title", propiedad.titulo)
        end
      end
    end
  end
end
