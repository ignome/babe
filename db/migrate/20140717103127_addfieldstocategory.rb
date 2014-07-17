class Addfieldstocategory < ActiveRecord::Migration
  def change
    add_column :categories, :title, :string
    add_column :categories, :keywords, :string
    add_column :categories, :description, :string
  end
end
