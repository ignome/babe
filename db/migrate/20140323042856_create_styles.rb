class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.integer :user_id
      t.string :cover
      t.integer :likes_count
      t.integer :comments_count

      t.timestamps
    end
  end
end
