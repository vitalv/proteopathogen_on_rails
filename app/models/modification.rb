class Modification < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :peptide
  validates :peptide_id, :presence => true
end
