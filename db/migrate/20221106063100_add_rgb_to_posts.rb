class AddRgbToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :r, :integer
    add_column :posts, :g, :integer
    add_column :posts, :b, :integer
  end
end
