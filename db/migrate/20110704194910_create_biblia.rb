class CreateBiblia < ActiveRecord::Migration
  def self.up
    create_table :biblia, :options => 'ENGINE=MyISAM' do |t|
      t.string :nome, :null => false
      t.string :permalink, :null => false
      t.integer :secoes_count, :null => false, :default => 0
      t.integer :livros_count, :null => false, :default => 0
      t.integer :capitulos_count, :null => false, :default => 0
      t.integer :versiculos_count, :null => false, :default => 0
    end
  end

  def self.down
    drop_table :biblia
  end
end