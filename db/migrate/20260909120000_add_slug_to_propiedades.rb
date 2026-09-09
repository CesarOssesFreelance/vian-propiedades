class AddSlugToPropiedades < ActiveRecord::Migration[8.1]
  class SluggedPropiedad < ActiveRecord::Base
    self.table_name = "propiedades"

    extend FriendlyId
    friendly_id :titulo, use: :slugged
  end

  def up
    add_column :propiedades, :slug, :string
    add_index :propiedades, :slug, unique: true

    SluggedPropiedad.reset_column_information
    SluggedPropiedad.find_each(&:save!)
  end

  def down
    remove_index :propiedades, :slug
    remove_column :propiedades, :slug
  end
end
