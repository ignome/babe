class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :title
      t.string :url
      t.string :cover
      t.string :provider
      t.decimal :price,  precision: 10, scale: 2
      t.decimal :mprice, precision: 10, scale: 2
      t.integer :status, limit: 2, default: 0
      t.timestamps
    end
  end
end
