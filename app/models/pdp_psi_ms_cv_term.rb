class PdpPsiMsCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :protein_detection_protocol
end
