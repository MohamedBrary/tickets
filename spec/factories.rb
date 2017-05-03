FactoryGirl.define do
  
  # user factory with different trait for each type
  factory :user do
    name "Test User"
    confirmed_at Time.now
    email "test@example.com"
    password "please123"
  end # of user factory

  # to make STI factories
  factory :admin, parent: :user, class: 'Admin' do end
  factory :agent, parent: :user, class: 'Agent' do end
  factory :customer, parent: :user, class: 'Customer' do end

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
      association :customer, strategy: :build
      association :agent, strategy: :build
    end
    
  end # of ticket factory

end # of FactoryGirl
