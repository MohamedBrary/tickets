module ApplicationHelper
	def user_types
		User.subclasses.collect{|type| type.to_s}
	end

	def allowed_user_types
		User.subclasses.collect{|type| type.to_s if type != Customer}.compact
	end
end
