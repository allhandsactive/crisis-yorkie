class CreateDecisions < ActiveRecord::Migration
  def self.up
    create_table :decisions do |t|
      t.string :name
      t.string :intern
      t.timestamps
    end
  end

  def self.down
    drop_table :decisions
  end
end
