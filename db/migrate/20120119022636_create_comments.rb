class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.primary_key :id
      t.text :texto
	  t.references :user
      t.references :versiculo

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
