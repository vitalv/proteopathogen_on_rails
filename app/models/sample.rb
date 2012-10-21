class Sample < ActiveRecord::Base
  # attr_accessible :title, :body
  :has_many :spectra_acquisition_runs
end
