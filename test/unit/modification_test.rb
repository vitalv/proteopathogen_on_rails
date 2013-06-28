require 'test_helper'

class ModificationTest < ActiveSupport::TestCase
  test "should not save without peptide id" do
    mod = Modification.new
    assert !mod.save, "Saved the modification withut peptide_id"
  end
  test "the truth" do 
    assert true
  end
end
