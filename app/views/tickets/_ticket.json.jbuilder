json.extract! ticket, :id, :desc, :report, :customer_id, :agent_id, :status, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
