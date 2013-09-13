FactoryGirl.define do
  factory :fragment do |f|
    association :spectrum_identification_item
    f.charge { rand(3) } 
    f.index { rand(100) }
    f.m_mz { rand(4000) + 1000 }
    f.m_intensity { rand(100000) + 10000 }
    error 0.01
    f.fragment_type { "frag:z+#{rand(3)} ion" }
    psi_ms_cv_fragment_type_accession "MS:100136X"
  end
end
