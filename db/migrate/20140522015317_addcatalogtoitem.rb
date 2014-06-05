class Addcatalogtoitem < ActiveRecord::Migration
  def change
    add_column :items, :catalog, :string, limit: 32
  end
end
