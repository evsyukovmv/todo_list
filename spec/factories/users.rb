FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end
end