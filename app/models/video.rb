class Video < ActiveRecord::Base
	belongs_to :user
	belongs_to :versiculo
	belongs_to :comment
end
