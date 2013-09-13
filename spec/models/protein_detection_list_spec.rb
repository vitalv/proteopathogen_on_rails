require 'spec_helper'

describe "An instance of", ProteinDetectionList do

  before "built with factory girl" do 
    @pdl = build(:protein_detection_list)
  end

  it "should be properly initialized" do  
    @pdl.should be_a(ProteinDetectionList)
  end
 
  it "should be valid on FactoryGirl build" do
    @pdl.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:protein_detection_list).should be_valid
  end
  
  it "should be invalid without pdl_id" do
    @pdl.pdl_id = nil
    @pdl.should_not be_valid
  end
  
  it "should be invalid without protein_detection_id" do
    @pdl.protein_detection_id = nil
    @pdl.should_not be_valid
  end

  it "should belong to ProteinDetection" do 
    @pdl.should belong_to(:protein_detection)
  end
  
  it "should have many protein_ambiguity_groups" do 
    @pdl.should have_many(:protein_ambiguity_groups)
  end

end


