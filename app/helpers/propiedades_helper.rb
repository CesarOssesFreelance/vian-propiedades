module PropiedadesHelper
  def tipo_propiedad(propiedad)
    { 0 => "Casa", 1 => "Departamento" }.fetch(propiedad.tipo_inmueble, "Propiedad")
  end

  def precio_propiedad(propiedad)
    number_to_currency(propiedad.precio, unit: "$", precision: 0, delimiter: ".", format: "%u%n")
  end

  def imagen_propiedad(propiedad)
    propiedad.imagenes.first || "img_#{(propiedad.id % 8) + 1}.jpg"
  end

  def propiedad_whatsapp_url(propiedad)
    detalles = [
      propiedad.titulo,
      "#{propiedad.tipo_inmueble.humanize} en #{propiedad.tipo_transaccion}",
      "Comuna: #{propiedad.comuna.nombre}",
      "Precio: #{precio_propiedad(propiedad)} CLP",
      ("Dormitorios: #{propiedad.dormitorios}" if propiedad.dormitorios.present?),
      ("Baños: #{propiedad.banos}" if propiedad.banos.present?),
      propiedad_url(propiedad)
    ].compact

    whatsapp_url("Hola, me interesó esta propiedad y me gustaría coordinar una visita:\n\n#{detalles.join("\n")}")
  end

  def youtube_embed_url(url)
    return if url.blank?

    uri = URI.parse(url)
    return unless %w[http https].include?(uri.scheme)

    video_id = case uri.host&.downcase
    when "youtu.be"
      uri.path.delete_prefix("/")
    when "youtube.com", "www.youtube.com", "m.youtube.com"
      if uri.path == "/watch"
        URI.decode_www_form(uri.query.to_s).to_h["v"]
      else
        uri.path.match(%r{\A/(?:embed|shorts|live)/([A-Za-z0-9_-]{11})/?\z})&.captures&.first
      end
    end
    return unless video_id&.match?(/\A[A-Za-z0-9_-]{11}\z/)

    "https://www.youtube-nocookie.com/embed/#{video_id}"
  rescue URI::InvalidURIError, ArgumentError
    nil
  end

end
