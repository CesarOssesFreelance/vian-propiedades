class CreatePropiedades < ActiveRecord::Migration[8.1]
  def change
    create_table :propiedades do |t|
      t.string :titulo, null: false
      t.text :descripcion

      t.integer :precio, null: false

      t.integer :dormitorios
      t.integer :banos
      t.integer :estacionamientos

      t.integer :metros_construidos
      t.integer :metros_terreno
      t.integer :piso

      t.integer :tipo_inmueble, null: false

      t.boolean :destacada, default: false, null: false
      t.boolean :publicada, default: false, null: false

      t.references :comuna, null: false, foreign_key: true

      t.timestamps
    end

    # 🔥 índices clave para performance
    add_index :propiedades, :precio
    add_index :propiedades, :dormitorios
    add_index :propiedades, :banos
    add_index :propiedades, :tipo_inmueble
    add_index :propiedades, :created_at

    # 🔥 índices compuestos para filtros reales
    add_index :propiedades, [:comuna_id, :tipo_inmueble]
    add_index :propiedades, [:precio, :tipo_inmueble]
    add_index :propiedades, [:comuna_id, :precio]
  end
end
