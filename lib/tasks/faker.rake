if defined?(Faker)
  # require 'ffaker'
  require 'populator'
  
  desc 'Load fake data for development/testing.'
  task :clean_db => ['db:drop', 'db:create', 'db:migrate', 'db:seed']
  task :clean_data => ['clean_db', 'faker:full_data']
  
  debug = false # to print out every step of the way


	namespace :faker do
	  desc "Used to populate database with data"
  	# TODO send them as params
	  num_customers = 10
	  num_agents = 5
	  num_tickets_per_customer = 5

	  task full_data: :environment do
	  	# creating agents
	  	create_agents(num_agents, debug)		
	  	# creating customers and their tickets
	  	create_customers_with_tickets(num_customers, num_tickets_per_customer, debug)

	  	print_stats(num_agents, num_customers, num_tickets_per_customer)
	  end # of task full_data

	  def create_agents num_agents, debug
  		puts "creating #{num_agents} agents".colorize(:green) if debug	  	
  		user_password = "123123123"
	  	Agent.populate num_agents do |user|
			  user.name    = Faker::Name.unique.name
			  user.email   = "#{user.name.parameterize(separator: '.')}@tickets.com"
			  # http://stackoverflow.com/a/16682286/426845
			  user.encrypted_password = User.new(:password => user_password).encrypted_password
			  user.created_at = 6.months.ago..4.months.ago
			  user.confirmed_at = user.created_at
			  user.sign_in_count = 0
			end # of creating agents
	  end # of create_agents

	  def create_customers num_customers, debug
  		puts "creating #{num_customers} customers".colorize(:green) if debug	  	
  		user_password = "123123123"
	  	Customer.populate num_customers do |user|
			  user.name    = Faker::Name.unique.name
			  user.email   = "#{user.name.parameterize(separator: '.')}@tickets.com"
			  user.encrypted_password = User.new(:password => user_password).encrypted_password
			  user.created_at = 4.months.ago..Time.now
			  user.confirmed_at = user.created_at
			  user.sign_in_count = 0
			end # of creating customers
	  end # of create_customers

	  def create_customers_with_tickets num_customers, num_tickets_per_customer, debug
	  	(1..num_customers).each do |index|
	  		puts "creating customer #{index}".colorize(:green) if debug
  			user_password = "123123123"
        # creating customer
        customer = Customer.create! do |user|
		      user.name    = Faker::Name.unique.name
				  user.email   = "#{user.name.parameterize(separator: '.')}@tickets.com"
				  user.password = user_password
	      	user.password_confirmation = user_password
			    user.created_at = rand(4.months.ago..3.months.ago) # after all agents are created
			  	user.confirmed_at = user.created_at
		    end

		    create_tickets customer, num_tickets_per_customer, debug
      end # of creating customers with their tickets
	  end # of create_customers_with_tickets

	  def create_tickets customer, num_tickets_per_customer, debug
  		puts "creating #{num_tickets_per_customer} tickets".colorize(:green) if debug
  		agent_ids = Agent.pluck :id

	  	# creating this customer tickets
	    Ticket.populate num_tickets_per_customer do |ticket|
			  ticket.customer_id    = customer.id
			  ticket.desc   = Faker::StarWars.quote + ' ' + Faker::ChuckNorris.fact
		    ticket.created_at = customer.created_at..Time.now
			  ticket.status = Ticket.statuses.values.sample

			  # add more info depedning on ticket status
			  if ticket.status == 1 # "assigned"
			  	ticket.agent_id = agent_ids.sample
			  elsif ticket.status == 2 #"resolved"
			  	ticket.agent_id = agent_ids.sample
			  	ticket.report = Faker::HarryPotter.quote
			  	ticket.resolution_date = ticket.created_at..Time.now
	  		end
			end # of populating tickets
	  end # of create_tickets

	  def print_stats num_agents, num_customers, num_tickets_per_customer
	  	num_tickets = num_customers*num_tickets_per_customer
  		user_password = "123123123"

	  	puts "Created #{num_agents} agents, #{num_customers} customers, and #{num_tickets} tickets.".colorize(:blue)
	  	
	  	tickets = Ticket.order("id desc").limit(num_tickets)
	  	puts "Tickets: #{tickets.pending.count} pending, #{tickets.assigned.count} assigned, and #{tickets.resolved.count} resolved.".colorize(:blue)
	  	
	  	puts "Use these credentials to test drive the system:".colorize(:cyan)
	  	puts "Customer '#{Customer.first.name}': '#{Customer.first.email}', password: '#{user_password}'".colorize(:cyan)
	  	# agent with most tickets assigned to him
	  	agent_id, tickets = Ticket.pluck(:agent_id).compact.each_with_object(Hash.new(0)){ |name, hash| hash[name] += 1}.max_by{|k,v| v}.first
	  	agent = Agent.find agent_id
	  	puts "Agent '#{agent.name}': '#{agent.email}', password: '#{user_password}'".colorize(:cyan)
	  end # of print_stats

	end # of namespace fake
end # of checking on Faker existence