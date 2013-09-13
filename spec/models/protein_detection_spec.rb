require 'spec_helper'

describe "An instance of", ProteinDetection do

  before "built with factory girl" do 
    @pd = build(:protein_detection)
  end

  it "should be properly initialized" do  
    @pd.should be_a(ProteinDetection)
  end
 
  it "should be valid on FactoryGirl build" do
    @pd.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:protein_detection).should be_valid
  end
  
  it "should be invalid without protein_detection_id" do
    @pd.protein_detection_id = nil
    @pd.should_not be_valid
  end

  it "should have many SpectrumIdentificationList" do 
    @pd.should have_many(:spectrum_identification_list)
  end
  
  it "should have one protein_detection_protocol" do 
    @pd.should have_one(:protein_detection_protocol)
  end

end

