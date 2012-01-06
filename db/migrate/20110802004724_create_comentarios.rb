class CreateComentarios < ActiveRecord::Migration
  def self.up
    create_table :comentarios, :options => 'ENGINE=MyISAM' do |t|
      t.string :href, :null => false
      t.integer :comment_id, :null => false
      t.references :parent_comment
      t.references :livro
      t.references :capitulo
      t.references :versiculo
      t.timestamps
    end
    
    add_index :comentarios, :comment_id, :unique => true
    add_index :comentarios, :parent_comment_id
    add_index :comentarios, :livro_id
    add_index :comentarios, :capitulo_id
    add_index :comentarios, :versiculo_id
    
    add_column :livros, :comentarios_count, :integer, :null => false, :default => 0
    add_column :capitulos, :comentarios_count, :integer, :null => false, :default => 0
    add_column :versiculos, :comentarios_count, :integer, :null => false, :default => 0
  end

  def self.down
    drop_table :comentarios
    
    remove_column :livros, :comentarios_count
    remove_column :capitulos, :comentarios_count
    remove_column :versiculos, :comentarios_count
  end
end
