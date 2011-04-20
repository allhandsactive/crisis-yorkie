class AddHumanHashColumns < ActiveRecord::Migration
  def self.up
    add_column :voters, :hashed_secret, :string
    add_column :voters, :public_identifier, :string
    add_column :voters, :salt, :string
  end

  def self.down
    # @todo
  end
end
