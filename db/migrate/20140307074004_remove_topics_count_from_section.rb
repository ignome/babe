class RemoveTopicsCountFromSection < ActiveRecord::Migration
  def change
    remove_column 'sections', :topics_count
  end
end
