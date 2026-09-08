class CreateCaracteristicas < ActiveRecord::Migration[8.1]
  def change
    create_table :caracteristicas do |t|
      t.string :nombre, null: false
      t.string :clave, null: false

      t.timestamps
    end

    add_index :caracteristicas, :nombre, unique: true
    add_index :caracteristicas, :clave, unique: true
  end
end
