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

  # only customer can create tickets
  # TODO discuss with client this rule, not allowing Admin to create tickets, for the integerity of the system
  def create?
  	user.customer?
  end

  # only admin or the customer who owns the ticket, can destroy it
  def destroy?
  	user.admin? || (user.customer? && ticket.customer == user)
  end

  # only agent can assign tickets, and only when it is pending
  # TODO discuss with client this rule, and discuss creating supervisor role
  def assign?
  	user.agent? && ticket.pending?
  end

  # only ticket's agent can resolve the ticket, and only when it is assigned
  # TODO discuss with client this rule, and discuss creating supervisor role, and if more complicated ticket flow is needed
  def resolve?
  	user.agent? && ticket.agent == user && ticket.assigned?
  end

end
