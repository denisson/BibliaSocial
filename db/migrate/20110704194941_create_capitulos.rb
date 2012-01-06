class CreateCapitulos < ActiveRecord::Migration
  def self.up
    create_table :capitulos, :options => 'ENGINE=MyISAM' do |t|
      t.integer :numero, :null => false
      t.references :biblia, :null => false
      t.references :secao, :null => false
      t.references :livro, :null => false
      t.integer :versiculos_count, :null => false, :default => 0
    end
    
    add_index :capitulos, :biblia_id
    add_index :capitulos, :secao_id
    add_index :capitulos, :livro_id
  end

  def self.down
    drop_table :capitulos
  end
end
