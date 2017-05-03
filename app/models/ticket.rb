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

  scope :months_ago, ->(months_count) { where("created_at > ?", months_count.months.ago) }
  scope :after_pending, -> {where("status > ?", Ticket.statuses['pending'])}

  def assign agent_id
    unless pending?
      errors.add(:base, 'Only pending tickets can be assigned') 
      return false
    end

  	self.agent_id = agent_id
    self.status = 'assigned'

  	self.save
  end

  def resolve report
    unless assigned?
      errors.add(:base, 'Only assigned tickets can be resolved')
      return false
    end

  	self.report = report
  	self.resolution_date = DateTime.now
  	self.status = 'resolved'

    self.save
  end
end
