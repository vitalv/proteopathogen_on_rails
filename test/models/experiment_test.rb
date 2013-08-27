require 'test_helper'

class ExperimentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save without organism" do
    e = Experiment.new
    #e.organism = "Candida"
    assert !e.save
  end
  
  test "should not save without protocol" do
    e = Experiment.new
    e.organism = "Candida"
    assert !e.save
  end
  
end
