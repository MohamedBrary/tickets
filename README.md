#Tickets Readme Document
#***********************

1. Prerequisites
=================
	1.1 Ruby 2.4.1
	--------------
	Usage of RVM is recommended:
	- To install RVM: 'https://rvm.io/rvm/install'
	- To install latest Ruby: 'https://rvm.io/rubies/installing'

	1.2 Rails 5.0.2
	---------------
	- Recommended to create a gemset for this project: 'https://rvm.io/gemsets/creating'
	- Then run command 'gem install rails -v 5.0.2'

	1.3 MySQL Server
	----------------
	- For Ubuntu 14.04: 'https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-14-04'
	- If you faced any problem, you can follow these instructions: 'https://askubuntu.com/a/489817/277986'
	- Similar tutorials exist for different distros

	1.4	WkHtmlToPdf
	---------------
	- For exporting html as PDF, wkhtmltopdf engine was used, and need to be installed.
	- Follow the simple instructions in this link to install it: 
		'https://gist.github.com/brunogaspar/bd89079245923c04be6b0f92af431c10'

2. Database Initialization
==========================
	- Normal db initialization for RoR application, running bundle to install mysql2 gem
	- Change 'db_user' and 'db_password' in 'config/secrets.yml', to match your settings
	- Run 'rake db:seed' to create Admin user, instructions to login as Admin would be printed out
	- In case if you need to populate the database with some data, so you can test drive the application, 
	  there is a rake that  creates 10 Customers, and 50 Tickets with different states, and would assign 
	  them randomly to 10 agents
		You have the following rakes ready for you:
		- 'rake faker:full_data' will populate these data
		- 'rake clean_data' will drop the databases, create them, migrate, seed, and then populate the 
		   database with new data

3. Assumptions
==============
	3.1 Tickets States
	------------------
	- Pending: the initial state, and requires only a Customer to create it, and a description
	- Assigned: when assigned to an Agent
	- Resolved: assigned Agent adds report, and resolve ticket, and then resoltion date is set

	3.2 Users Creation
	------------------
	- There are 3 types of users: Customer, Agent, and Admin
	- Only Customer can normally sign up
	- Only Admin can create Admins and Agents (can't create customers)
	- When Admin or Agent is created, they recieve an email with confirmaiton link, and instructions to login
	- After successful login, user will be redirected to change his password, if he doesn't, each time he 
	  logins will be reminded and redirected to change his password

	3.3 Ticket Authorization
	------------------------
	- Customer can see only his tickets
	- Only Customer can create and destroy his tickets
	- Customer can update his tickets if not already resolved
	- Agent can see pending tickets, and tickets assigned to himself
	- Only Agent can assign a ticket to himself, if ticket is pending and not yet assigned
	- Agent can resolve tasks assigned to him
	- Admin can see all tickets, and destroy them (he can't edit them)

	3.3 User Authorization
	----------------------
	- Customer and Agent can see and edit their own data
	- Admin can CRUD all users, but he can't create a Customer
	
	3.4 Roles Remarks
	-----------------
	- I didn't create SuperAdmin that can do anything, as I don't recommend creating this type of users
	  unless it is very clear and communicated to the product owner and how dangerous it is to have that
	  kind of authority
	- Only after clear communication with product owner, we can create SuperAdmin, and I would recommedn using
	  percuations, like soft deletions, and usage of 'paranoid' gem
	- Depending on the complexity of the system, I would recommend AgentSupervisor, so he can manage and 
	  assign all tickets
	- Currently when Customer is destroyed, all his tickets are destroyed, this needs also discussion with 
	  product owner, to understand whethere this application is Customer oriented, or Ticket oriented, or
	  Agent oriented, and which data is more important, and needed for later statistics and reports

4. Future Work
==============
	- Usage of frontend framework and testing frontend, instead just simple bootstrap haml views
	- API and its test
	- Complete design document

5. Instructions
===============
	- After prerequisites are met, there are no special instructions to run the Rails app
	- 'rails s' to run the server
	- 'rspec' to run the tests