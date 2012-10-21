class DbSequence < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :peptide_evidences
  validates :accession, :presence => true
  validates :sequence, :presence => true
end
