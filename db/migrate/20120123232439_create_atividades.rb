class CreateAtividades < ActiveRecord::Migration
  def self.up
    create_table :atividades do |t|
      t.primary_key :id
	  t.references :user
      t.references :versiculo
	  t.references :item, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :atividades
  end
end
