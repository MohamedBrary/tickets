FactoryGirl.define do
  
  # user factory with different trait for each type
  factory :user do
    name "Test User"
    confirmed_at Time.now
    email "test@example.com"
    password "please123"

    trait :admin do
      type 'Admin'
    end

    trait :customer do
      type 'Customer'
    end

    trait :agent do
      type 'Agent'
    end
  end # of user factory

  factory :ticket do
    desc   'Test ticket description'

    trait :pending do
      status 'pending'
      association :customer, factory: [:user, :customer]
    end

    trait :assigned do
      status 'assigned'
      association :customer, factory: [:user, :customer]
      association :agent, factory: [:user, :agent]
    end

    trait :resolved do
      status 'resolved'
      report 'Test ticket report'
      association :customer, factory: [:user, :customer]
      association :agent, factory: [:user, :agent]
    end
    
  end # of ticket factory

end # of FactoryGirl
