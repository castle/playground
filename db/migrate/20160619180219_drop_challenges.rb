class DropChallenges < ActiveRecord::Migration
  def change
    drop_table :challenges
  end
end
