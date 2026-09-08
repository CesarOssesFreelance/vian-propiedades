class CreatePropiedadCaracteristicas < ActiveRecord::Migration[8.1]
  def change
    create_table :propiedad_caracteristicas do |t|
      t.references :propiedad, null: false, foreign_key: true
      t.references :caracteristica, null: false, foreign_key: true

      t.timestamps
    end


    # 🔥 evita duplicados (MUY importante)
    add_index :propiedad_caracteristicas,
              [:propiedad_id, :caracteristica_id],
              unique: true,
              name: "idx_prop_carac_unique"
  end
end
