class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.string :title
      t.integer :items_count

      t.timestamps
    end
  end
end
