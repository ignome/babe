class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string :name
      t.integer :user_id
      t.integer :parent_id, default: 0
      t.string :slug
      t.integer :sort
      t.integer :childs, :integer, default: 0
      t.timestamps
    end
  end
end
