require 'faker'

FactoryGirl.define do
  factory :protein_detection_hypothesis do |f|
    pass_threshold "true"
    f.name { Faker::Lorem.word + "ine"}
    sequence(:protein_detection_hypothesis_id) { |i| "orf19.100#{i}2" }
    association :protein_ambiguity_group 
  end
end
