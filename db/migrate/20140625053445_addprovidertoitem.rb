class Addprovidertoitem < ActiveRecord::Migration
  def change
    add_column :items, :provider, :string, limit: 16
    # limit 8 equals bigint
    add_column :items, :iid, :integer, limit: 8, default: 0

    add_index "items", ['provider', 'iid'], name: 'provider', unique: true
  end

end
