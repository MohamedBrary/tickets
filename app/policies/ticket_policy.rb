class TicketPolicy < ApplicationPolicy
  
  class Scope < Scope
    
    def resolve
    	# admin has access to all tickets
      if user.admin?
        scope.all
      elsif user.customer?
      	# customer can see his own tickets only
        scope.where(customer_id: user.id)
      elsif user.agent?
      	# agent can see pending tickets or his own tickets
        scope.where(agent_id: user.id).or(scope.pending)
      end
    end

  end

  def index?
  	true
  end

  def month_report?
    index?
  end

  # only customer can create tickets
  # TODO discuss with client this rule, not allowing Admin to create tickets, for the integerity of the system
  def create?
  	user.customer?
  end

  # customer can edit his own ticket if it isn't already resolved
  # TODO discuss with client this rule
  def update?
  	user.customer? && record.customer == user && !record.resolved?
  end

  # only admin or the customer who owns the ticket, can destroy it
  def destroy?
  	user.admin? || (user.customer? && record.customer == user)
  end

  # only agent can assign tickets, and only when it is pending
  # TODO discuss with client this rule, and discuss creating supervisor role
  def assign?
  	user.agent? && record.pending?
  end

  # only ticket's agent can resolve the ticket, and only when it is assigned
  # TODO discuss with client this rule, and discuss creating supervisor role, and if more complicated ticket flow is needed
  def resolve?
  	resolved?
  end

  # only ticket's agent can resolve the ticket, and only when it is assigned
  # TODO discuss with client this rule, and discuss creating supervisor role, and if more complicated ticket flow is needed
  def resolved?
    user.agent? && record.assigned? && record.agent_id == user.id
  end

  def scope
    Pundit.policy_scope!(user, Ticket)
  end

  def permitted_attributes
    # customer can edit only the description of the ticket
    if user.customer?
      [:desc]
    # agent can edit only the report of the ticket
    elsif user.agent?
      [:report]
    end
  end

end
