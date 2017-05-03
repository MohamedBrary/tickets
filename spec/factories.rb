require 'faker'

FactoryGirl.define do
  
  # mail generator using Faker  
  sequence :email do |n|
    Faker::Internet.email
  end

  # user factory with different trait for each type
  factory :user do
    name "Test User"
    confirmed_at Time.now
    email 
    password "please123"
  end # of user factory

  # to make STI factories
  factory :admin, parent: :user, class: 'Admin' do end
  factory :agent, parent: :user, class: 'Agent' do end
  factory :customer, parent: :user, class: 'Customer' do end

  # ticket factory
  factory :ticket do
    desc   'Test ticket description'

    trait :pending do
      status 'pending'
      # association :customer, factory: [:user, :customer], strategy: :build # if it was a trait
      association :customer, strategy: :build
    end

    trait :assigned do
      status 'assigned'
      association :customer, strategy: :build
      association :agent, strategy: :build
    end

    trait :resolved do
      status 'resolved'
      report 'Test ticket report'
      resolution_date Time.now
      association :customer, strategy: :build
      association :agent, strategy: :build
    end

    trait :customer_persisted do
      association :customer
    end

    trait :agent_persisted do
      association :agent
    end

    trait :complete do
      status 'resolved'
      report 'Test ticket report'
      resolution_date Time.now
      association :customer
      association :agent
    end
    
  end # of ticket factory

end # of FactoryGirl
