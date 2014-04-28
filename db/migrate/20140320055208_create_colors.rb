class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.integer :item_id
      t.string :hex, limit: 6
      t.integer :r, limit: 3
      t.integer :g, limit: 3
      t.integer :b, limit: 3
      t.float :percent, limit: 6

      t.timestamps
    end
  end
end
