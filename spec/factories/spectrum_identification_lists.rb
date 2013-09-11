FactoryGirl.define do
  factory :spectrum_identification_list do |f|
    sequence(:sil_id) { |i| "SIL_#{i}"}    
    f.num_seq_searched { rand(6000) }
    association :spectrum_identification
    association :protein_detection
  end
end
