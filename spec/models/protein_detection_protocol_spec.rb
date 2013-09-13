require 'spec_helper'

describe "An instance of", ProteinDetectionProtocol do

  before "built with factory girl" do 
    @pdp = build(:protein_detection_protocol)
  end

  it "should be properly initialized" do  
    @pdp.should be_a(ProteinDetectionProtocol)
  end
 
  it "should be valid on FactoryGirl build" do
    @pdp.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:protein_detection_protocol).should be_valid
  end
  
  it "should be invalid without pdp_id" do
    @pdp.pdp_id = nil
    @pdp.should_not be_valid
  end

  it "should be invalid without protein_detection_id" do
    @pdp.protein_detection_id = nil
    @pdp.should_not be_valid
  end

  it "should be invalid without analysis_software" do
    @pdp.analysis_software = nil
    @pdp.should_not be_valid
  end

  it "should belong to protein detection" do 
    @pdp.should belong_to(:protein_detection)
  end

end


