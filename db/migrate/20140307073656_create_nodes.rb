class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :section_id
      t.string :name
      t.integer :sort
      t.integer :topics_count
      t.string :description

      t.timestamps
    end
  end
end
