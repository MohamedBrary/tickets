require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "user types" do
    it "it lists all user types" do
      expect(helper.user_types).to match_array(["Admin", "Agent", "Customer"])
    end
  end

  describe "allowed user types" do
    it "it lists all user types that an admin can create" do
      expect(helper.allowed_user_types).to match_array(["Admin", "Agent"])
    end
  end

  # declared in ApplicationController using helper_method helper
  # describe "current user type" do
  #   it "it returns the type of the current user" do
  #   	current_user = create(:admin)
  #     expect(helper.current_user_type).to be "admin"
  #   end
  # end
end
