require 'faker'

FactoryGirl.define do
  factory :modification do |f|
    residue "L"
    location "1"
    avg_mass_delta "6.0201"
    unimod_accession "UNIMOD:188"
    association :peptide_evidence
    association :peptide_sequence
  end
end
