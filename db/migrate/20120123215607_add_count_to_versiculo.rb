class AddCountToVersiculo < ActiveRecord::Migration
  def self.up
	change_table :versiculos do |t|
	  t.integer :comments_count, :null => false, :default => 0
	  t.integer :referencias_count, :null => false, :default => 0
	  t.integer :links_count, :null => false, :default => 0
	  t.integer :videos_count, :null => false, :default => 0
	  t.integer :atividades_count, :null => false, :default => 0
    end
  end

  def self.down
	remove_column :versiculos, :comments_count
	remove_column :versiculos, :referencias_count
	remove_column :versiculos, :links_count
	remove_column :versiculos, :videos_count
	remove_column :versiculos, :atividades_count
  end
end