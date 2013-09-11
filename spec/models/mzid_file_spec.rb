require 'spec_helper'

describe "An instance of", MzidFile do  #"feature" is alias for "describe ..., :type => :feature"

  before "built with factory girl" do 
    @mzidf = FactoryGirl.build(:mzid_file)
  end

  it "has a valid factory" do
    FactoryGirl.create(:mzid_file).should be_valid
  end

  it "should be properly initialized" do  
    expect(@mzidf).to be_a(MzidFile)  
  end

  it "should be valid with the factoryGirl-build" do
    @mzidf.should be_valid 
  end

  it "should be invalid without name" do
    @mzidf.name = nil
    @mzidf.should_not be_valid
    expect(@mzidf).to have(1).errors_on(:name)
  end
 
  it "should be invalid without location" do
    @mzidf.location = nil
    @mzidf.should_not be_valid
    expect(@mzidf).to have(1).errors_on(:location)
  end
  
  it "should be invalid without experiment_id" do
    @mzidf.experiment_id = nil
    expect(@mzidf).to have(1).errors_on(:experiment_id)
  end
  
  
  it "should have many spectrum identifications" do
    #m = MzidFile.reflect_on_association(:spectrum_identifications)
    #m.macro.should == :has_many
    #with the shoulda-matchers gem I can test associations like:
    @mzidf.should have_many(:spectrum_identifications)
  end
  
end
