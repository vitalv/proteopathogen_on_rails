class DbSequence < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :peptide_evidences
  validates :accession, :presence => true
  #validates :sequence, :presence => true
  validates_uniqueness_of :accession, :scope => :search_database_id
  belongs_to :search_database
  validates :search_database_id, :presence => true
end
