# app/services/filter_tickets_service.rb

# to be used in Tickets index, and exposedt to Tickets API call
class FilterTicketsService

	def initialize(params)
    @status = params[:status]
    @date = params[:date]
    @tickets = params[:tickets]
  end

  def filter
  	# apply filter, if exists
    @tickets = @tickets.where(status: @status) if @status.present?
    @tickets = @tickets.months_ago(@date.to_i) if @date.present?
    @tickets
  end

  def description
    desc = "Tickets"
    desc = "#{@status.titleize} #{desc}" if @status.present?
    desc = "Last #{@date =='1' ? 'Month' : 'Quarter'} #{desc}" if @date.present?
    desc
  end

end
