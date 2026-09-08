class CreateRegiones < ActiveRecord::Migration[8.1]
  def change
    create_table :regiones do |t|
      t.string :nombre, null: false

      t.timestamps
    end

    add_index :regiones, :nombre, unique: true
  end
end
