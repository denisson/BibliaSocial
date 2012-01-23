class Referencia < ActiveRecord::Base
	belongs_to :user
	belongs_to :comment
	belongs_to :versiculo
	belongs_to :versiculo_citado, :class_name => "Versiculo"
	
end
