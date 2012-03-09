class AddCountsToComment < ActiveRecord::Migration
  def self.up
	change_table :comments do |t|
	  t.integer :referencias_count, :null => false, :default => 0
	  t.integer :links_count, :null => false, :default => 0
	  t.integer :videos_count, :null => false, :default => 0
    end
  end

  def self.down
	remove_column :comments, :referencias_count
	remove_column :comments, :links_count
	remove_column :comments, :videos_count
  end
end