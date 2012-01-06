class CreateSecoes < ActiveRecord::Migration
  def self.up
    create_table :secoes, :options => 'ENGINE=MyISAM' do |t|
      t.string :nome, :null => false
      t.string :permalink, :null => false
      t.references :biblia, :null => false
      t.integer :livros_count, :null => false, :default => 0
      t.integer :capitulos_count, :null => false, :default => 0
      t.integer :versiculos_count, :null => false, :default => 0
    end
    
    add_index :secoes, :biblia_id
  end

  def self.down
    drop_table :secoes
  end
end
