require 'faker'

FactoryGirl.define do
  factory :protein_detection do |f|
    sequence(:protein_detection_id) { |i| "PD_#{i}"}    
    f.name { Faker::Lorem.word}
  end
end
