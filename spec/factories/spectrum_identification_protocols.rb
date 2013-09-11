require 'faker'

FactoryGirl.define do
  factory :spectrum_identification_protocol do |f|  
    sequence(:sip_id) { |i| "SIP_#{i}"}    
    f.analysis_software { Faker::Lorem.word + "er v1.0" }
    f.search_type "ms ms search"
    f.threshold "no threshold"
    f.parent_tol_plus_value "1.5"
    f.parent_tol_minus_value "-1.5"
    f.fragment_tol_plus_value "0.05"
    f.fragment_tol_minus_value "-0.05"
    association :spectrum_identification
  end
end


