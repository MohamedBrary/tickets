module ApplicationHelper
	def user_types
		User.subclasses.collect{|type| type.to_s}
	end

	def allowed_user_types
		User.subclasses.collect{|type| type.to_s if type != Customer}.compact
	end

	def user_name
		current_user.present? ? current_user.name : 'Guest'
	end
end
