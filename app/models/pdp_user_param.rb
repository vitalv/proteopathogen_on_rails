class PdpUserParam < ActiveRecord::Base
  belongs_to :protein_detection_protocol
  # attr_accessible :title, :body
end
