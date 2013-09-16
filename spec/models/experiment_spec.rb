require 'spec_helper'

describe "An instance of", Experiment do  #"feature" is alias for "describe ..., :type => :feature"

  before "built with factory girl" do 
    #@user = User.new
    @experiment = FactoryGirl.build(:experiment) ## Returns a User instance that's not saved
  end

  it "should be valid when created" do
    FactoryGirl.create(:experiment).should be_valid
  end

  it "should be properly initialized" do  
    expect(@experiment).to be_a(Experiment)  
  end

  it "should be valid with the factoryGirl-built organism and protocol" do
    @experiment.should be_valid #RSpec's `be_valid` matcher
  end

  it "should be invalid without organism" do
    @experiment.organism = nil
    @experiment.should_not be_valid
    expect(@experiment).to have(1).errors_on(:organism)
  end
  
  it "should be invalid without protocol" do
    @experiment.protocol = nil
    expect(@experiment).to have(1).errors_on(:protocol)
  end
  
end

