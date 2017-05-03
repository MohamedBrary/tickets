require 'rails_helper'
# include Warden::Test::Helpers
# Warden.test_mode!

RSpec.describe UsersController, type: :controller do
  
  # after(:each) do
  #   Warden.test_reset!
  # end

  describe "GET #index as admin" do
		login_admin

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads all of the users into @users" do
    	User.where("id != ?",  controller.current_user.id).destroy_all # clear users table
      user1, user2 = create(:customer), create(:agent)
      get :index
      expect(assigns(:users)).to match_array([user1, user2, controller.current_user]) # used for login
    end
  end # of #index

end