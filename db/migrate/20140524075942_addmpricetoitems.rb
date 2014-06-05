class Addmpricetoitems < ActiveRecord::Migration
  def change
    add_column :items, :mprice, :decimal, precision: 10, scale: 2
  end
end
