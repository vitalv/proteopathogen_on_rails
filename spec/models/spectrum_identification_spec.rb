require 'spec_helper'

describe "An instance of", SpectrumIdentification do

  before "built with factory girl" do 
    @si = FactoryGirl.build(:spectrum_identification)
  end

  it "has a valid factory" do
    FactoryGirl.create(:spectrum_identification).should be_valid
  end

  it "should be properly initialized" do  
    expect(@si).to be_a(SpectrumIdentification)  
  end

  it "should be valid with the factoryGirl-build" do
    @si.should be_valid 
  end

  it "should be invalid without si_id" do
    @si.si_id = nil
    @si.should_not be_valid
    expect(@si).to have(1).errors_on(:si_id)
  end
 
  it "should be invalid without mzid_file" do
    @si.mzid_file_id = nil
    @si.should_not be_valid
    expect(@si).to have(1).errors_on(:mzid_file_id)
  end
  
  it "should belong to mzid file" do 
    @si.should belong_to(:mzid_file)
  end

    
end
