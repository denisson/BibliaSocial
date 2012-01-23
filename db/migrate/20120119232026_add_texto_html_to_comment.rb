class AddTextoHtmlToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :texto_html, :text
  end

  def self.down
    remove_column :comments, :texto_html
  end
end
