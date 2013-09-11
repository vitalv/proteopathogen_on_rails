require 'faker'

FactoryGirl.define do
  factory :spectrum_identification do |f|  
    sequence(:si_id) { |i| "SI_#{i}"}    
    f.name { Faker::Lorem.word + "_spectrum_identification" }
    sequence(:activity_date) { |i| (i*rand).days.ago }
    association :mzid_file
  end
end

