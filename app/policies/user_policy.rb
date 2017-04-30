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

  def index?
    user.admin?
  end

  # admin can create an admin or an agent
  def create?
    user.admin? && (record.agent? || record.admin?)
  end

  def destroy?
    user.admin?
  end

  def update?
    user == record
  end
end
