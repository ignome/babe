class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.boolean :recommend
      t.boolean :available

      t.timestamps
    end
  end
end
