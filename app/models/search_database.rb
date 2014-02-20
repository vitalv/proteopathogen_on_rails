class SearchDatabase < ActiveRecord::Base

  has_and_belongs_to_many :spectrum_identifications, :join_table => :sip_sdb_join_table
  before_destroy { |sdb| sdb.spectrum_identifications.clear } #avoids orphans in join table
  
  #self.location = "/unkown/location" if self.location == nil or self.location == ""
  
  validates :location, presence: true #attribute location is required in <SearchDatabase> in the mzid file
  
  has_many :db_sequences, dependent: :destroy
  
end
