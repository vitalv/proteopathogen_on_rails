require 'spec_helper'

#note: Feature and scenario are a part of Capybara, and not rspec, and are meant to be used for acceptance and integration tests

feature "experiments" do

  background do
    @exp = FactoryGirl.create(:experiment)
    #assume there is (one at least) an associated mzid file (uploaded, I don't validate a exp has associated mzid files to save the exp, bc I may upload it whenever)
    @exp.mzid_files = [FactoryGirl.create(:mzid_file)]
    @mzid_files_ids = @exp.mzid_files.ids
    visit experiments_path
    print page.html
  end
  
  scenario "displays the mzidf_tables correctly with links to their si_s" do 
    @mzid_files_ids.each do |mzidf_id|
      within "table.my_table#mzidf_table_#{mzidf_id}" do 
        page.should have_link "mzidf_#{mzidf_id}_si"
        click_link "mzidf_#{mzidf_id}_si"
        #current_path.should == mzid_file_spectrum_identifications_path(mzidf_id)
        print current_path
      end
    end
  end
    
end

