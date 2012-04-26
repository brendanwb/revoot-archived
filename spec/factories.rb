FactoryGirl.define do
  factory :user do
    name     "Brendan Buckingham"
    email    "brendan@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end