class Ticket < ApplicationRecord
  belongs_to :customer
  belongs_to :agent

  # explicitly mapping the status enum, to make sure that the default status is always 'pending
  enum status: { pending: 0, assigned: 1, resolved: 2 }

  
  validates :desc, presence: true
  validates :status, presence: true
  validates :customer, presence: true # each ticket should belongs to a customer upon creation
  validates :agent, presence: true, if: :assigned? # each ticket should belongs to an agent, if it is assigned
  validates :report, presence: true, if: :resolved? # each ticket should have a report, if it is resolved
  validates :resolution_date, presence: true, if: :resolved? # each ticket should have a resolution_date, if it is resolved
end
