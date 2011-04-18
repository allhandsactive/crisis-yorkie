class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :voter_id
      t.integer :vote_ordinal
      t.integer :decision_id
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
