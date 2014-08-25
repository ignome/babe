class Addfavoritescounttoitem < ActiveRecord::Migration
  def change
    add_column :items, :favorites_count, :integer, default: 0
    add_column :bookmarks, :items_count, :integer, default: 0
  end
end
