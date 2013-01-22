class Experiment < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :mzid_files
  validates :organism, :presence => true
  validates :protocol, :presence => true  
end
