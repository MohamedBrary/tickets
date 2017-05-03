require 'rails_helper'

RSpec.describe User, type: :model do

	describe '.create' do
	  it 'should be invalid without name' do
	    user = build(:admin)
	    user.name = nil
	    user.valid?
	    expect(user.errors[:name]).to include("can't be blank")
	  end

	  it 'should be invalid without email' do
	    user = build(:admin)
	    user.email = nil
	    user.valid?
	    expect(user.errors[:email]).to include("can't be blank")
	  end

	  it 'should be invalid without type' do
	    user = build(:admin)
	    user.type = nil
	    user.valid?
	    expect(user.errors[:type]).to include("can't be blank")
	  end

	  it 'should pass with email, name and type' do
	    expect(build(:admin).valid?).to be true
	  end

	end # of User.create

end # User model

