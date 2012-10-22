class Sample < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :spectra_acquisition_runs
  validates :organism, :presence => true
  validates :protocol, :presence => true
end
