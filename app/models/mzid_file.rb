class MzidFile < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :location, :presence => true
  validates :sha1, :uniqueness => true
  validates :name, :presence => true
  has_many :spectra_acquisition_runs, :dependent => :destroy
  validates_associated :spectra_acquisition_runs
end
