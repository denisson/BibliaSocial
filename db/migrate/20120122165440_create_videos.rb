class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.primary_key :id
      t.string :thumb_url
	  t.string :link_url
	  t.string :player_url
	  t.string :titulo
	  t.references :user
	  t.references :comment
      t.references :versiculo	
	
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
