require 'spec_helper'


#this is mor a controller spec than a feature spec, you should move it to spec/controllers and use "describe" instead of "feature"

feature "GET 'experiments/index' " do

  background  do 
    @mzid_file = create(:mzid_file)
    visit experiments_path    
  end

  scenario "should be linked to the mzid files controller #index action" do  
    #@all_mzid_files.should_not be_empty
    assigns(:all_mzid_files).should include  :mzid_file    
  end

end
