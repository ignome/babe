class ChangePhotoToPolymorphic < ActiveRecord::Migration
  def change
    rename_column 'photos', 'topic_id', 'subject_id'
    add_column :photos, :subject, :string, limit: 32
  end
  #add_index :photos, ['subject', 'subject_id'], name: 'index on subject'
end
