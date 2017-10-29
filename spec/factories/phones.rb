FactoryGirl.define do
  factory :phone do
    association :contact
    phone '123-5555-1234'
    phone_type 'home'
  end
end
