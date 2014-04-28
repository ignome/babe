class Addbodytostyle < ActiveRecord::Migration
  def change
    add_column :styles, :body, :string
  end
end
