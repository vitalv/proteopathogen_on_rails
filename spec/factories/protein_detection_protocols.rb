require 'faker'

FactoryGirl.define do
  factory :protein_detection_protocol do |f|
    f.analysis_software { Faker::Lorem.word + "er v1.9"}
    f.name { Faker::Lorem.word + "_protein_detection"}
    sequence(:pdp_id) { |i| "PDP_#{i}" }
    association :protein_detection 
  end
end

