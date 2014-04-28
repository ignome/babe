class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.integer :section_id
      t.integer :user_id
      t.text :body
      t.integer :likes_count

      t.timestamps
    end

  add_index 'topics', ['section_id'], name: 'index on section'
  add_index 'topics', ['user_id'], name: 'user published topics'
  end

  
end
