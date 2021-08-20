class CreateInventoryMovements < ActiveRecord::Migration[6.1]
  def change
    create_table :inventory_movements do |t|
      t.references :product, null: false, foreign_key: true
      t.references :storage_place, null: false, foreign_key: true
      t.string :movement_type, :limit => 1
      t.date :date
      t.integer :quantity

      t.timestamps
    end
  end
end
