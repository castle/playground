class AddLockToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lock, :boolean, :default => true
  end
end
