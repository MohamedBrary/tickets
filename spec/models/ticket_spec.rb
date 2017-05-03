require 'rails_helper'

RSpec.describe Ticket, type: :model do

	describe '.create' do
	  it 'should be invalid without desc' do
	    ticket = build(:ticket, :pending)
	    ticket.desc = nil
	    ticket.valid?
	    expect(ticket.errors[:desc]).to include("can't be blank")
	  end

	  it 'should be invalid without status' do
	    ticket = build(:ticket, :pending)
	    ticket.status = nil
	    ticket.valid?
	    expect(ticket.errors[:status]).to include("can't be blank")
	  end

	  it 'should be invalid without a customer' do
	    ticket = build(:ticket, :pending)
	    ticket.customer = nil
	    ticket.valid?
	    expect(ticket.errors[:customer]).to include("can't be blank")
	  end
	end # of Ticket.create

	describe '#assign' do
	  it 'should fail if not pending' do
	    ticket = build(:ticket, :assigned)
	    ticket.assign(1) # dummy agent_id
	    expect(ticket.errors[:base]).to include("Only pending tickets can be assigned")
	  end

	  it 'should fail without agent' do
	    ticket = build(:ticket, :pending)
	    ticket.assign(nil) # assigning to nil agent
	    expect(ticket.errors[:agent]).to include("can't be blank")
	  end

	  it 'should pass' do
	    ticket = build(:ticket, :pending)
	    agent = create(:agent) # have to create to pass presence validation with 'agent'
	    expect(ticket.assign(agent.id)).to eq true
	  end
	end # of Ticket#assign

	describe '#resolve' do
	  it 'should fail if not assigned' do
	    ticket = build(:ticket, :pending)
	    ticket.resolve("report") # dummy report
	    expect(ticket.errors[:base]).to include("Only assigned tickets can be resolved")
	  end

	  it 'should fail without report' do
	    ticket = build(:ticket, :assigned)
	    ticket.resolve(nil) # assigning to nil agent
	    expect(ticket.errors[:report]).to include("can't be blank")
	  end

	  it 'should pass' do
	    ticket = build(:ticket, :assigned)
	    expect(ticket.resolve("report")).to eq true
	  end
	end # of Ticket#resolve

end # Ticket model

