class Addbookmarkscounttouser < ActiveRecord::Migration
  def change
    add_column :users, :bookmarks_count, :integer, default: 0
  end
end
