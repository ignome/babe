class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :title
      t.string :slug
      t.integer :width
      t.integer :height
      t.string :description

      t.timestamps
    end
  end
end
