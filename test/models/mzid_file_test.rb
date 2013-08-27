require 'test_helper'

class MzidFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "should not save without required attributes" do
    mzidf = MzidFile.new
    assert !mzidf.save
  end
  
end



#model
#  validates :location, presence: true
#  validates :sha1, uniqueness: true
#  validates :name, presence: true
#  validates :experiment_id, presence: true
