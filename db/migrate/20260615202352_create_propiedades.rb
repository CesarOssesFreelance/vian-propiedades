class CreatePropiedades < ActiveRecord::Migration[8.1]
  def change
    create_table :propiedades do |t|
      t.string :titulo, null: false
      t.text :descripcion

      t.integer :precio, null: false

      t.integer :tipo_inmueble, null: false
      t.integer :tipo_transaccion, null: false

      t.integer :dormitorios
      t.integer :banos
      t.integer :estacionamientos

      t.integer :metros_construidos
      t.integer :metros_terreno
      t.integer :piso

      t.string :video_url

      t.boolean :destacada, default: false, null: false
      t.boolean :publicada, default: false, null: false

      t.references :comuna, null: false, foreign_key: true

      t.timestamps
    end

    # Índices individuales
    add_index :propiedades, :precio
    add_index :propiedades, :dormitorios
    add_index :propiedades, :banos
    add_index :propiedades, :tipo_inmueble
    add_index :propiedades, :tipo_transaccion
    add_index :propiedades, :destacada
    add_index :propiedades, :publicada
    add_index :propiedades, :created_at

    # Índices compuestos para filtros frecuentes
    add_index :propiedades, [:comuna_id, :tipo_inmueble]
    add_index :propiedades, [:comuna_id, :tipo_transaccion]
    add_index :propiedades, [:tipo_inmueble, :tipo_transaccion]
    add_index :propiedades, [:precio, :tipo_inmueble]
    add_index :propiedades, [:comuna_id, :precio]
  end
end