class RemoveSessionIdFromAuth < ActiveRecord::Migration
  def change
  remove_column :authentications, :session_id, :string
  end
end
