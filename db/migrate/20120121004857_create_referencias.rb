class CreateReferencias < ActiveRecord::Migration
  def self.up
    create_table :referencias do |t|
      t.primary_key :id
      t.string :ref
	  t.references :user
      t.belongs_to :versiculo
	  t.belongs_to :versiculo_citado
	  t.references :comment
	
      t.timestamps
    end
  end

  def self.down
    drop_table :referencias
  end
end
