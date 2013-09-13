FactoryGirl.define do
  factory :protein_ambiguity_group do |f|
    sequence(:protein_ambiguity_group_id) { |i| "PAG_#{i}" }
    association :protein_detection_list
  end
end
