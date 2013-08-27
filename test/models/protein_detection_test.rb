require 'test_helper'

class ProteinDetectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save protein detection without pd id" do 
    pd = ProteinDetection.new
    assert !pd.save
  end
end
