class AddItemToComment < ActiveRecord::Migration
  def self.up
	change_table :comments do |t|
		t.references :item, :polymorphic => true
	end
  end

  def self.down
	remove_column :comments, :item_id
	remove_column :comments, :item_type
  end
end
