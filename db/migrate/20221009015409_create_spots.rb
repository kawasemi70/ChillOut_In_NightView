class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.references :post, null: false, foreign_key: true
      t.string :address, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      

      t.timestamps
    end
  end
end
