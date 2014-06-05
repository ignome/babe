class CreateTaskLinks < ActiveRecord::Migration
  def change
    create_table :task_links do |t|
      t.string :title
      t.string :cover
      t.string :url
      t.decimal :price, precision: 10, scale: 2
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
