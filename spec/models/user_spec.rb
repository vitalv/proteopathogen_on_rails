require 'spec_helper'

describe "An instance of", User do  #"feature" is alias for "describe ..., :type => :feature"

  before "built with factory girl" do 
    #@user = User.new
    @user = FactoryGirl.build(:user) ## Returns a User instance that's not saved
  end

  it "should be properly initialized" do  
    expect(@user).to be_a(User)  
  end

  it "should be valid with the factoryGirl-built user name and password" do
    @user.should be_valid #RSpec's `be_valid` matcher
  end

  it "should be invalid without email" do
    @user.email = nil
    @user.should_not be_valid
    expect(@user).to have(1).errors_on(:email)
  end
  
  it "should be invalid without passwrd" do
    @user.password = nil
    expect(@user).to have(1).errors_on(:password)
  end
  
  
end
