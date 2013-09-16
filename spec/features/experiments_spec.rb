require 'spec_helper'

#note: Feature and scenario are a part of Capybara, and not rspec, and are meant to be used for acceptance and integration tests

feature "experiments" do

  background do
    @mzidf = FactoryGirl.create(:mzid_file)
    visit experiments_path
    #@exp_id = @mzidf.experiment.id
    #print page.html
  end
  
  scenario "displays Spectrum Identification Link for the corresponding MzidFile/Experiment" do
    within "table.my_table#exp_table_#{@mzidf.id}" do 
      page.should have_link "> Spectrum Identification"
      click_link "si_#{@mzidf.id}"
    end
    current_path.should == experiment_spectrum_identifications_path(@mzidf.id)
    #print current_path
  end
    
end

