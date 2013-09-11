require 'faker'

FactoryGirl.define do
  factory :mzid_file do |f|  
    sequence(:sha1) { |i| "Sha1 - #{i}"}    
    mzidfname = f.name { Faker::Lorem.word + ".mzid" }
    f.location "/home/vital/proteopathogen_on_rails/public/uploaded_mzid_files/" + "#{mzidfname}"    
    f.creator { Faker::Name.name }      
    sequence(:experiment_id) { |i| "Experiment - #{i}" }
  end
end

