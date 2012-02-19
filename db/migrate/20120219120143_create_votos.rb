class CreateVotos < ActiveRecord::Migration
  def self.up
    create_table :votos do |t|
      t.references :user, :null => false
      t.integer :pontuacao, :null => false
      t.references :votavel, :null => false, :polymorphic => true
      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :votos
  end
end
