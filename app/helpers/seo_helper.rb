module SeoHelper
  SITE_NAME = "Vian Propiedades"
  SITE_URL = "https://vianpropiedades.cl"
  DEFAULT_TITLE = "Vian Propiedades | Venta y arriendo en la Región de Valparaíso"
  DEFAULT_DESCRIPTION = "Compra, vende o arrienda propiedades en Viña del Mar, Reñaca, Concón, Valparaíso, Quilpué y Villa Alemana con asesoría inmobiliaria cercana y profesional."
  DEFAULT_IMAGE_PATH = "/og-vian-propiedades.jpg"

  def seo_title
    content_for(:seo_title).presence || content_for(:title).presence || DEFAULT_TITLE
  end

  def seo_description
    text = content_for(:seo_description).presence || DEFAULT_DESCRIPTION
    truncate(strip_tags(text.to_s).squish, length: 160, separator: " ")
  end

  def seo_canonical_url
    path = content_for(:seo_canonical_path).presence || request.path
    path = root_path if controller_name == "home" && action_name == "index"
    path = propiedades_path if controller_name == "propiedades" && action_name == "index"
    URI.join("#{SITE_URL}/", path.to_s.delete_prefix("/")).to_s
  end

  def seo_image_url
    image = content_for(:seo_image).presence || DEFAULT_IMAGE_PATH
    return image if image.to_s.start_with?("http://", "https://")

    URI.join("#{SITE_URL}/", image.to_s.delete_prefix("/")).to_s
  end

  def seo_image_alt
    content_for(:seo_image_alt).presence || "Logo de Vian Propiedades"
  end

  def seo_robots
    return "noindex, follow" if request.query_parameters.present?
    return "index, follow, max-image-preview:large" if seo_indexable_page?

    "noindex, nofollow"
  end

  def seo_og_type
    controller_name == "propiedades" && action_name == "show" ? "website" : "website"
  end

  def seo_structured_data
    graph = [seo_business_schema, seo_web_page_schema]
    graph << seo_website_schema if controller_name == "home" && action_name == "index"
    graph << seo_property_schema if controller_name == "propiedades" && action_name == "show" && @propiedad&.publicada?
    { "@context" => "https://schema.org", "@graph" => graph.compact }
  end

  private

  def seo_indexable_page?
    return true if controller_name == "home" && action_name == "index"
    return true if controller_name == "propiedades" && action_name == "index"
    return @propiedad.publicada? if controller_name == "propiedades" && action_name == "show" && @propiedad

    false
  end

  def seo_business_schema
    {
      "@type" => ["Organization", "RealEstateAgent"],
      "@id" => "#{SITE_URL}/#organization",
      "name" => SITE_NAME,
      "url" => "#{SITE_URL}/",
      "logo" => {
        "@type" => "ImageObject",
        "url" => "#{SITE_URL}#{DEFAULT_IMAGE_PATH}",
        "width" => 1536,
        "height" => 1024
      },
      "email" => "vianpropiedades@gmail.com",
      "sameAs" => [
        "https://www.instagram.com/vianpropiedades",
        "https://www.tiktok.com/@vian.propiedades"
      ],
      "areaServed" => %w[Viña\ del\ Mar Reñaca Concón Valparaíso Quilpué Villa\ Alemana].map do |name|
        { "@type" => "City", "name" => name }
      end
    }
  end

  def seo_website_schema
    {
      "@type" => "WebSite",
      "@id" => "#{SITE_URL}/#website",
      "url" => "#{SITE_URL}/",
      "name" => SITE_NAME,
      "alternateName" => "Vian",
      "inLanguage" => "es-CL",
      "publisher" => { "@id" => "#{SITE_URL}/#organization" }
    }
  end

  def seo_web_page_schema
    {
      "@type" => "WebPage",
      "@id" => "#{seo_canonical_url}#webpage",
      "url" => seo_canonical_url,
      "name" => seo_title,
      "description" => seo_description,
      "inLanguage" => "es-CL",
      "isPartOf" => { "@id" => "#{SITE_URL}/#website" },
      "about" => { "@id" => "#{SITE_URL}/#organization" },
      "primaryImageOfPage" => { "@type" => "ImageObject", "url" => seo_image_url }
    }
  end

  def seo_property_schema
    images = @propiedad.imagenes.map { |image| rails_blob_url(image, host: "vianpropiedades.cl", protocol: "https") }
    images.unshift(rails_blob_url(@propiedad.imagen_principal, host: "vianpropiedades.cl", protocol: "https")) if @propiedad.imagen_principal.attached?
    images = [seo_image_url] if images.empty?

    {
      "@type" => "RealEstateListing",
      "@id" => "#{seo_canonical_url}#listing",
      "url" => seo_canonical_url,
      "name" => @propiedad.titulo,
      "description" => seo_description,
      "image" => images.uniq,
      "datePosted" => @propiedad.created_at.to_date.iso8601,
      "dateModified" => @propiedad.updated_at.iso8601,
      "inLanguage" => "es-CL",
      "publisher" => { "@id" => "#{SITE_URL}/#organization" },
      "about" => {
        "@type" => @propiedad.departamento? ? "Apartment" : "Residence",
        "name" => @propiedad.titulo,
        "address" => {
          "@type" => "PostalAddress",
          "addressLocality" => @propiedad.comuna.nombre,
          "addressRegion" => @propiedad.comuna.region.nombre,
          "addressCountry" => "CL"
        },
        "numberOfBedrooms" => @propiedad.dormitorios,
        "numberOfBathroomsTotal" => @propiedad.banos,
        "floorSize" => (@propiedad.metros_construidos && {
          "@type" => "QuantitativeValue", "value" => @propiedad.metros_construidos, "unitCode" => "MTK"
        })
      }.compact,
      "offers" => {
        "@type" => "Offer",
        "price" => @propiedad.precio,
        "priceCurrency" => "CLP",
        "availability" => "https://schema.org/InStock",
        "url" => seo_canonical_url
      }
    }
  end
end
