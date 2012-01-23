class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.primary_key :id
      t.string :url
	  t.references :user
	  t.references :comment
      t.references :versiculo
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
