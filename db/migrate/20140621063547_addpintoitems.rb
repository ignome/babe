class Addpintoitems < ActiveRecord::Migration
  def change
    add_column :items, :status, :int, default: 0
  end
end
