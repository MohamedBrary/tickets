module ApplicationHelper
	def user_types
		User.subclasses.collect{|type| type.to_s}
	end
end
