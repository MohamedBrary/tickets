class UserPolicy < ApplicationPolicy
  
  class Scope < Scope
  	# admin can see all users, other type of users can only see themselves
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end

end
