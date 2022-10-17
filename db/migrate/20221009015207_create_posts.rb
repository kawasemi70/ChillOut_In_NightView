class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :customer_id, null: false
      t.string :title, null: false
      t.string :body, null: false

      t.string "address", default: "", null: false
      t.float "latitude"
      t.float "longitude"

      t.float "chillout", null: false
      t.float "atmosphere", null: false
      t.float "beautiful", null: false
      t.float "access", null: false
      t.float "congestion", null: false
      t.float "evaluation", null: false


      t.timestamps
    end
  end
end
