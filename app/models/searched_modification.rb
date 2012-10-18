class SearchedModification < ActiveRecord::Base
  # attr_accessible :title, :body
  has_and_belongs_to_many :spectrum_identification_protocols, :join_table => 'sip_searched_mod_join_table'
  validates :unimod_accession, :presence => true
end
