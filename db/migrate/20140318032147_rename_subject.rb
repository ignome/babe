class RenameSubject < ActiveRecord::Migration
  def change
    rename_column 'photos', 'subject', 'subject_type'
  end
end
