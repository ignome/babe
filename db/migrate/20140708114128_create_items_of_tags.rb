class CreateItemsOfTags < ActiveRecord::Migration
  def change
    create_table :items_of_tags do |t|
      t.integer :item_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
