class CreateAlternatives < ActiveRecord::Migration
  def self.up
    create_table :alternatives do |t|
      t.string :name
      t.integer :index
      t.integer :question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :alternatives
  end
end
