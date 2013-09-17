require 'spec_helper'

describe ExperimentsController do

  describe "GET #index " do
  
    it "generates list of experiments" do
      exp = FactoryGirl.create(:experiment)
      get :index
      assigns(:experiments).should eq([exp])
      
    end
    
    it "displays the :index view" do
      get :index
      response.should render_template :index 
    end
    
  end

end
