class ProteinDetection < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :spectrum_identification_lists
  has_one :protein_detection_list, :dependent => :destroy
end
