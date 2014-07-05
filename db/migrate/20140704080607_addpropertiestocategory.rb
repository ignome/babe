class Addpropertiestocategory < ActiveRecord::Migration
  def change
    add_column :categories, :display, :boolean, default: true
    add_column :categories, :recommend, :boolean, default: false
  end
end
