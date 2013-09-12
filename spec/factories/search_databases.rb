FactoryGirl.define do
  factory :search_database do |f|
    sequence(:sdb_id) { |i| "SDB_#{i}" }
    name "Candida Genome Databse A.21"
    version "v1.0"
    location "/some/absolute/or/relative/path/SC5314Candida.fasta"
    sequence(:release_date) { |i| i.years.ago }
    number_of_sequences 6320
  end
end
