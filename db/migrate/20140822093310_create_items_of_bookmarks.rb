class CreateItemsOfBookmarks < ActiveRecord::Migration
  def change
    create_table :items_of_bookmarks do |t|
      t.integer :item_id
      t.integer :bookmark_id
      t.string :description, limit: 140

      t.timestamps
    end
  end
end
