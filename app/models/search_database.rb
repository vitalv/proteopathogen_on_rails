class SearchDatabase < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :spectrum_identification_protocols
  validates :location, :presence => true #attribute location is required in <SearchDatabase> in the mzid file
end
