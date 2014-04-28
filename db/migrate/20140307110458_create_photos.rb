class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.integer :topic_id
      t.string :name
      t.string :file
      t.integer :sort

      t.timestamps
    end
  end
end
