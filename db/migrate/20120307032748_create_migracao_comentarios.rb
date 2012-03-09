class CreateMigracaoComentarios < ActiveRecord::Migration
  def self.up
    create_table :migracao_comentarios do |t|
      t.primary_key :id
      t.text :texto
	    t.string :facebook_user_id
      t.references :versiculo

      t.timestamps
    end
  end

  def self.down
    drop_table :migracao_comentarios
  end
end
