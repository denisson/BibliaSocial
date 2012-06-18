class AddNomeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :nome, :string, :null => false
  end

  def self.down
    remove_column :users, :nome
  end
end
