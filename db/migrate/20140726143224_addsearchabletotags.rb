class Addsearchabletotags < ActiveRecord::Migration
  def change
    add_column :tags, :searchable, :boolean, default: false
  end
end
