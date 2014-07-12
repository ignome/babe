class Addcategorytotag < ActiveRecord::Migration
  def change
    add_column :tags, :category_id, :integer, default: 0
  end
end
