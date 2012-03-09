class AddLikesCountToComment < ActiveRecord::Migration
  def self.up
	change_table :comments do |t|
	  t.integer :likes_count, :null => false, :default => 0
	  t.integer :dislikes_count, :null => false, :default => 0
    end
  end

  def self.down
	remove_column :comments, :likes_count
	remove_column :comments, :dislikes_count
  end
end