require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.email { Faker::Internet.email } 
    f.password { Faker::Lorem.words[0] }
  end
end
