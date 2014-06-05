class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.integer :position_id
      t.integer :user_id
      t.string :description
      t.string :url
      t.string :cover
      t.boolean :available, default: true
      t.integer :start_on
      t.integer :expires_on

      t.timestamps
    end
  end
end
