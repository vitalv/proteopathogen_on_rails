FactoryGirl.define do
  factory :peptide_hypothesis do |f|
    association :protein_detection_hypothesis
    association :peptide_spectrum_assignment
  end
end
