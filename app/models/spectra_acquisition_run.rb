class SpectraAcquisitionRun < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :spectrum_identification_protocols, :dependent => :destroy
  belongs_to :sample
end
