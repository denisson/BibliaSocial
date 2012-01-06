class CreateLivros < ActiveRecord::Migration
  def self.up
    create_table :livros, :options => 'ENGINE=MyISAM' do |t|
      t.integer :numero, :null => false
      t.string :nome, :null => false
      t.string :permalink, :null => false
      t.references :biblia, :null => false
      t.references :secao, :null => false
      t.integer :capitulos_count, :null => false, :default => 0
      t.integer :versiculos_count, :null => false, :default => 0
    end
    
    add_index :livros, :biblia_id
    add_index :livros, :secao_id
    add_index :livros, :numero
  end

  def self.down
    drop_table :livros
  end
end
