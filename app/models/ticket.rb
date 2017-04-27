class Ticket < ApplicationRecord
  belongs_to :customer
  belongs_to :agent

  enum status: [ :pending, :assigned, :resolved ]
end
