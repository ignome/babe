class Renameitemid < ActiveRecord::Migration
  def change
    rename_column :colors, :item_id, :photo_id
    add_column :photos, :colors, :string, limit: 64
  end
end
