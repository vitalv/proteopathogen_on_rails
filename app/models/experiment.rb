class Experiment < ActiveRecord::Base
  # attr_accessible :title, :body

  extend FriendlyId
  friendly_id :short_label, use: :slugged

  has_many :mzid_files, dependent: :destroy
  validates :organism, presence: true
  validates :short_label, presence: true
  
end
