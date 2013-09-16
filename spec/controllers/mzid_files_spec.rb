require 'spec_helper'


#this is mor a controller spec than a feature spec, you should move it to spec/controllers and use "describe" instead of "feature"

describe MzidFilesController do
 
  describe "GET #index " do
  
    it "generates list of mzid files" do
      mzidf = FactoryGirl.create(:mzid_file)
      get :index
      assigns(:all_mzid_files).should eq([mzidf]) #@all_mzid_files
      
    end
    
    it "displays the :index view" do
      get :index
      response.should render_template :index  
    end
    
  end
  

end
