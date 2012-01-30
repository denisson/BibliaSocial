class AddTituloToLink < ActiveRecord::Migration
  def self.up
    add_column :links, :titulo, :string
  end

  def self.down
    remove_column :links, :titulo
  end
end
