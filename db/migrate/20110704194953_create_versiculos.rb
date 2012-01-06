class CreateVersiculos < ActiveRecord::Migration
  def self.up
    create_table :versiculos, :options => 'ENGINE=MyISAM' do |t|
      t.integer :numero, :null => false
      t.text :texto
      t.references :biblia, :null => false
      t.references :secao, :null => false
      t.references :livro, :null => false
      t.references :capitulo, :null => false
    end
    
    add_index :versiculos, :biblia_id
    add_index :versiculos, :secao_id
    add_index :versiculos, :livro_id
    add_index :versiculos, :capitulo_id
  end

  def self.down
    drop_table :versiculos
  end
end
