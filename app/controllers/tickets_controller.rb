class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :assign, :resolve, :resolved]
  before_action :authorize_ticket

  # GET /tickets
  # GET /tickets.json
  def index
    # apply auth logic
    @tickets = policy_scope(Ticket).includes(:customer, :agent)    
    # gather tickets stats
    set_tickets_stats
    # based on filter params if exists
    filter_tickets

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "ticket_report"   # Excluding ".pdf" extension.
      end
    end
  end

  # GET /tickets/month_report
  # GET /ticketsmonth_report/.pdf
  # GET /tickets/month_report.json
  def month_report
    redirect_to tickets_path(status: 'resolved', date: '1', format: request.format.symbol)
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    render "tickets/#{current_user_type}/show"
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    # only customers are allowed to create tickets
    @ticket.customer = current_user

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /tickets/1/assign
  def assign
    respond_to do |format|
      if @ticket.assign(current_user.id)
        format.html { redirect_to resolve_ticket_path(@ticket), notice: "Ticket was successfully assigned to #{current_user.name} ." }
        format.json { render :resolve, status: :ok, location: @ticket }
      else
        format.html { render :show }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tickets/1/resolve
  def resolve    
  end

  # POST /tickets/1/resolved
  def resolved
    respond_to do |format|
      if @ticket.resolve(ticket_params[:report])
        format.html { redirect_to @ticket, notice: "Ticket was successfully resolved by #{current_user.name} ." }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :resolve }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      # making sure that current user has access to the ticket
      @ticket = policy_scope(Ticket).where(id: params[:id]).first
    end

    def authorize_ticket
      # authorize the set ticket, or the Class ticket in case the ticket isn't initialized
      authorize (@ticket || Ticket)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      # using pundit helper for authorized ticket attributes
      params.require(:ticket).permit(policy(@ticket || Ticket).permitted_attributes)
      # params.require(:ticket).permit(:desc, :report, :customer_id, :agent_id, :status, :resolution_date)
    end

    # TODO move to service
    def set_tickets_stats
      # gather stats
      @tickets_count = @tickets.count
      @pending_tickets_count = @tickets.pending.count
      @assigned_tickets_count = @tickets.assigned.count
      @resolved_tickets_count = @tickets.resolved.count

      @month_tickets_count = @tickets.months_ago(1).count
      @quarter_tickets_count = @tickets.months_ago(3).count
    end

    def filter_tickets
      filtering_service = FilterTicketsService.new status: params[:status], date: params[:date], tickets: @tickets

      # making a readable description to user filter
      @desc = filtering_service.description
      @tickets = filtering_service.filter      
    end
end
