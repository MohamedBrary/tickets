require 'rails_helper'

RSpec.describe TicketsController, type: :controller do

  describe "GET #index as admin" do
		admin = login_admin

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the tickets into @tickets" do
    	Ticket.destroy_all # clear tickets table
      ticket1, ticket2 = create_pair(:ticket, :complete)
      get :index

      expect(assigns(:tickets)).to match_array([ticket1, ticket2])
    end
  end # of #index as admin

  describe "GET #index as customer" do
		login_customer

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads only customer tickets into @tickets" do
    	Ticket.destroy_all # clear tickets table
      ticket1 = create(:ticket, :complete)
      ticket2 = build(:ticket, :complete)
      ticket2.customer = controller.current_user
      ticket2.save
      get :index

      expect(assigns(:tickets)).to match_array([ticket2])
    end
  end # of #index as customer

  describe "GET #index as agent" do
		login_agent

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads only agent and pending tickets into @tickets" do
    	Ticket.destroy_all # clear tickets table
      ticket1 = create(:ticket, :complete)
      ticket2, ticket3 = build_pair(:ticket, :complete)
      ticket2.status = 'pending'
      ticket2.save
      ticket3.agent = controller.current_user
      ticket3.save
      get :index

      expect(assigns(:tickets)).to match_array([ticket2, ticket3])
    end
  end # of #index as agent
end