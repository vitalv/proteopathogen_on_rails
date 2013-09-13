require 'spec_helper'

describe "An instance of", ProteinAmbiguityGroup do

  before "built with factory girl" do 
    @pag = build(:protein_ambiguity_group)
  end

  it "should be properly initialized" do  
    @pag.should be_a(ProteinAmbiguityGroup)
  end
 
  it "should be valid  on FactoryGirl build" do
    @pag.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:protein_ambiguity_group).should be_valid
  end
  
  it "should be invalid without protein_ambiguity_group_id" do
    @pag.protein_ambiguity_group_id = nil
    @pag.should_not be_valid
  end
  
  it "should be invalid without pdl_id" do
    @pag.protein_detection_list_id = nil
    @pag.should_not be_valid
  end

  it "should belong to ProteinDetectionList" do 
    @pag.should belong_to(:protein_detection_list)
  end
  
  it "should have many protein_detection_hypotheses" do 
    @pag.should have_many(:protein_detection_hypotheses)
  end

end





