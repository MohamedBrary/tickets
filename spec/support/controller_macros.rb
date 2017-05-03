module ControllerMacros
  def login_admin
    login_user FactoryGirl.create(:admin)
  end

  def login_agent
    login_user FactoryGirl.create(:agent)
  end

  def login_customer
    login_user FactoryGirl.create(:customer)
  end

  def login_user user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user.confirm # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in user
    end
  end

end