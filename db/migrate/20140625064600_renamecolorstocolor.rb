class Renamecolorstocolor < ActiveRecord::Migration
  def change
    rename_column :photos, :colors, :color
  end
end
