class CreateItemsOfStyles < ActiveRecord::Migration
  def change
    create_table :items_of_styles do |t|
      t.integer :item_id
      t.integer :style_id

      #t.timestamps
    end
    add_index 'items_of_styles', ['style_id', 'item_id'], unique: true
  end
end
