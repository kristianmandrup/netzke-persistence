FactoryGirl.define do
  factory :role do
    name  "user"
  end

  factory :user do
    email                 { "#{rand(10**10)}@email.com" }
    password              "blahblah"
    password_confirmation "blahblah"
    association           :role
  end
end