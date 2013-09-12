require 'faker'

FactoryGirl.define do
  factory :spectrum_identification_result do |f|
    sequence(:sir_id) { |i| "SIR_#{i}"}
    association :spectrum_identification_list
    f.spectrum_id { "#{rand(1000)}" + "_spectrum_id" }
    f.spectrum_name { Faker::Lorem.word + "_spectrum_name" }
  end
end
