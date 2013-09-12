FactoryGirl.define do
  factory :peptide_evidence do |f|
    sequence(:pepev_id) { |i| "PEPEV_#{i}"}
    f.start  { rand(100) }
    pre "K"
    f. post { "#{(65 + rand(26)).chr}" }
    is_decoy "false"
    association :db_sequence
    association :peptide_sequence
  end
end
