FactoryGirl.define do
  factory :peptide_spectrum_assignment do |f|
    association :spectrum_identification_item
    association :peptide_evidence
  end
end
