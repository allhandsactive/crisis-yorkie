class AddWindow < ActiveRecord::Migration
  def self.up
    add_column :decisions, :open_at, :datetime
    add_column :decisions, :closed_at, :datetime
  end

  def self.down
    # @todo
  end
end
