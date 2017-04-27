class AgentsController < Devise::RegistrationsController

  # GET /agents/new
  def new
    @agent = Agent.new
  end

  # GET /agents/1/edit
  def edit
  end

  def create
    build_resource(sign_up_params)
    if resource.save
      redirect_to admin_editors_path
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end
