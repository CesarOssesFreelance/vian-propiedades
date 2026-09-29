namespace :images do
  desc "Generate and store optimized image variants sequentially"
  task warm_variants: :environment do
    requested = ENV.fetch("VARIANTS", "card,hero,gallery,thumbnail,social")
                   .split(",").map(&:strip).reject(&:blank?).map(&:to_sym)
    unknown = requested - Propiedad::IMAGE_VARIANTS.keys
    abort "Unknown variants: #{unknown.join(", ")}" if unknown.any?

    scope = ENV["ALL"] == "1" ? Propiedad.all : Propiedad.where(publicada: true)
    total = scope.count
    failures = []

    scope.find_each.with_index(1) do |property, index|
      main = property.imagen_principal.attachment
      gallery = property.imagenes.attachments.to_a
      jobs = []
      jobs << [main, requested] if main
      gallery.each { |attachment| jobs << [attachment, requested & %i[gallery thumbnail]] }
      jobs << [gallery.first, [:social]] if main.nil? && gallery.first && requested.include?(:social)
      puts "[#{index}/#{total}] #{property.slug}: #{jobs.size} images"

      jobs.each do |attachment, variants|
        variants.each do |variant|
          attachment.variant(variant).processed
        rescue StandardError => error
          failures << "#{property.slug}/#{attachment.filename}/#{variant}: #{error.class}"
          warn failures.last
        end
      end
    end

    abort "Variant generation failed for #{failures.size} images" if failures.any?
    puts "Optimized variants ready."
  end
end
