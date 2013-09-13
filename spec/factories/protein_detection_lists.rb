FactoryGirl.define do
  factory :protein_detection_list do |f|
    sequence(:pdl_id) { |i| "PDL_#{i}" }
    association :protein_detection
  end
end
