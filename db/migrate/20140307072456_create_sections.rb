class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.string :slug
      t.integer :user_id
      t.integer :sort
      t.integer :topics_count, default: 0

      t.timestamps
    end
  end
end
