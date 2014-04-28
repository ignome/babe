class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.string :subject
      t.integer :subject_id
      t.string :subject_type
      t.text :body

      t.timestamps
    end
  end
end
