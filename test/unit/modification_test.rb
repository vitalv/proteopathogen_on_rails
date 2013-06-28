require 'test_helper'

class ModificationTest < ActiveSupport::TestCase
  test "should not save without peptide id" do
    mod = Modification.new
    assert !mod.save
  end
  test "the truth" do 
    assert true
  end
end
