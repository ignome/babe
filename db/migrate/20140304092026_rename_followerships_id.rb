class RenameFollowershipsId < ActiveRecord::Migration
  def change
    rename_column 'followerships', 'follower', 'follower_id'
    rename_column 'followerships', 'following', 'following_id'
  end
end
