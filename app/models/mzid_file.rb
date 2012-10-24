class MzidFile < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :location, :presence => true
  validates :sha1, :uniqueness => true
  validates :name, :presence => true
  has_many :spectrum_identification_protocols #No :dependent => :destroy
  validates_associated :spectrum_identification_protocols
end
