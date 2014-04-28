class RenameSectionToNodeForTopic < ActiveRecord::Migration
  def change
    rename_column 'topics', :section_id, :node_id
  end
end
