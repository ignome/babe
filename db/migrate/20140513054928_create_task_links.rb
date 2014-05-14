class CreateTaskLinks < ActiveRecord::Migration
  def change
    create_table :task_links do |t|
      t.string :title
      t.string :url
      t.string :cover
      t.integer :status, limit: 1, default: 0

      t.timestamps
    end
  end
end
