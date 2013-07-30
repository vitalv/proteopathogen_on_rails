class DbSequence < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :peptide_evidences
  #validates :sequence, :presence => true
  validates :accession, uniqueness: {scope: :search_database_id}, presence: true
  belongs_to :search_database
  validates :search_database_id, presence: true
end
