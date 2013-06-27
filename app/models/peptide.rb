class Peptide < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sequence, :presence => true
  validates :peptide_id, :presence => true #must be present, bc I find_or_create_by_peptide_id in mzid_2_db
  has_many :peptide_evidences
  has_many :modifications
end
