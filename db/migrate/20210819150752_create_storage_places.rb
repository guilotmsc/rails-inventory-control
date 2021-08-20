class CreateStoragePlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_places do |t|
      t.string :name, :limit => 20

      t.timestamps
    end
  end
end
