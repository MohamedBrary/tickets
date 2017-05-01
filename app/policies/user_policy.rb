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

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def update?
    user.admin? || user == record
  end

  def permitted_attributes
    # only admin can change type
    if user.admin?
      [:name, :email, :password, :password_confirmation, :type]
    else
      [:name, :email, :password, :password_confirmation]
    end
  end
end
