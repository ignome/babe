class CreateTaskPages < ActiveRecord::Migration
  def change
    create_table :task_pages do |t|
      t.string :url
      t.integer :status, default: 0
      t.timestamps
    end

    #change_column :task_links, :status, :boolean, default: false
    #add_column :task_links, :price, :decimal, precision: 10, scale: 2
  end
end
