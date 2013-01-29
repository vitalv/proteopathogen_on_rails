class Peptide < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :sequence, :presence => true
  has_many :peptide_evidences
  #has_many :modifications
end
