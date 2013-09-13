require 'spec_helper'

describe "An instance of", Fragment do

  before "built with factory girl" do 
    @fr = build(:fragment)
  end

  it "should be properly initialized" do  
    @fr.should be_a(Fragment)
  end
 
  it "should be valid  on FactoryGirl build" do
    @fr.should be_valid 
  end

  it "should be valid on FactoryGirl create" do
    create(:fragment).should be_valid
  end
  
  it "should be invalid without sii_id" do
    @fr.spectrum_identification_item_id = nil
    @fr.should_not be_valid
  end
  
  it "should belong to spectrum_identification_item" do
    @fr.should belong_to(:spectrum_identification_item)
  end

end




