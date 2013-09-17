require 'spec_helper'

#note: Feature and scenario are a part of Capybara, and not rspec, and are meant to be used for acceptance and integration tests

feature "spectrum identifications" do

  background do
    @si = FactoryGirl.create(:spectrum_identification)    
    @mzid_file = @si.mzid_file
    @si.spectrum_identification_list = FactoryGirl.create(:spectrum_identification_list)
    @si.spectrum_identification_list.spectrum_identification_results = [FactoryGirl.create(:spectrum_identification_result)]
    #@mzid_files_ids = @exp.mzid_files.ids
    #spectrum_identification_results_path(spectrum_identification.id)    
    visit mzid_file_spectrum_identifications_path(mzid_file_id: @mzid_file.id)
    #print page.html
  end
  
  scenario "displays the si tables correctly with links to their sir_s" do 
    #@mzid_files_ids.each do |mzidf_id|
      within "table.my_table#si_table_#{@si.id}" do
        page.should have_link "si_#{@si.id}_results"
        click_link "si_#{@si.id}_results"
        current_path.should == spectrum_identification_results_path(@si.id)
        print current_path
      end
    #end
  end
   
end

