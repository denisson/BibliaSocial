class AddCitacoesCountToVersiculo < ActiveRecord::Migration
  def self.up
	change_table :versiculos do |t|
	  t.integer :citacoes_count, :null => false, :default => 0
    end
  end

  def self.down
	remove_column :versiculos, :citacoes_count
  end
end