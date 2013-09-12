require 'faker'

FactoryGirl.define do
  factory :db_sequence do |f|
    f.accession  { "orf19." + Faker::Lorem.word }
    f.description  { Faker::Lorem.paragraph }
    sequence(:sequence) { "#{(0...rand(200)+10).map{ ('A'..'Z').to_a[rand(26)] }.join}" } 
    association :search_database    
  end
  
end
