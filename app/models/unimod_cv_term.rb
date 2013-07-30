class UnimodCvTerm < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :accession, presence: true
  validates :name, presence: true
end
