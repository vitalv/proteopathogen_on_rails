FactoryGirl.define do
  factory :spectrum_identification_item do |f|
    sequence(:sii_id) { |i| "SII_#{i}"}    
    f.charge_state { rand(6) }
    f.exp_m2z { rand(1500) }
    f.calc_m2z { rand(1500) }
    f.rank { rand(3) }
    pass_threshold "true"
    association :spectrum_identification_result
  end
end
