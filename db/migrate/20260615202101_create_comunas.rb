class CreateComunas < ActiveRecord::Migration[8.1]
  def change
    create_table :comunas do |t|
      t.string :nombre, null: false
      t.references :region, null: false, foreign_key: true

      t.timestamps
    end

    add_index :comunas, :nombre
    add_index :comunas, [:region_id, :nombre], unique: true
  end
end