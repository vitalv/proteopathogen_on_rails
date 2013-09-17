require 'faker'

FactoryGirl.define do
  factory :experiment do |f|
    f.organism "Candida albicans SC5313"
    f.protocol { Faker::Lorem.paragraph }
    sequence(:date) { |i| i.days.ago }
    f.researcher { Faker::Name.name }
    #association :mzid_file
  end
end

