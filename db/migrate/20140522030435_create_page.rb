class CreatePage < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :catalog_id
      t.integer :user_id
      t.string :title
      t.string :slug
      t.string :keywords
      t.string :description
      t.integer :sort
      t.text :body
      t.boolean :status

      t.timestamps
    end
  end
end
