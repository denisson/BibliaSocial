class AddProfileToUser < ActiveRecord::Migration
  def self.up
	change_table :users do |t|
		t.has_attached_file :foto
	end
  end

  def self.down
	drop_attached_file :users, :foto
  end
end
