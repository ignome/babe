class Addcommentscounttoitem < ActiveRecord::Migration
  def change
    add_column :items, :comments_count, :integer, default: 0
    add_column :items, :views_count, :integer, default: 0
    
  end
end
