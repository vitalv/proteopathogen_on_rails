FactoryGirl.define do

  factory :mzid_file do
  
    sequence(:sha1) { |i| "Sha1 - #{i}"}    
    name "Defaut Mzid File Name"
    location "/home/vital/proteopathogen_on_rails/public/uploaded_mzid_files/" + "#{name}"    
    sequence(:creator) { |i| "Mzid file creator - #{i}" }    
    
    trait :silac do
      name "SILAC_phos_OrbitrapVelos_1_interact-ipro-filtered.mzid"
    end
      
  end
end

