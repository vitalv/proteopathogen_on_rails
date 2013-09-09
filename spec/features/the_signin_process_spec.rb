require 'spec_helper'

#feature is in fact just an alias for describe ..., :type => :feature, 
#background is an alias for before, 
#scenario for it, 
#and given/given! aliases for let/let!, respectively

#describe "the signin process", :type => :feature do #is therefore the same as:
feature 'Signing in' do 

  background do
    #User.create(:email => 'vital@farm.ucm.es', :password => 'proteo.que')
    user = FactoryGirl.create(:user)
  end

  scenario "with correct credentials" do
    visit '/sessions/new' do
    #within("#form") do
      fill_in('email', :with => user.email)
      fill_in('password', :with => user.password)
    end
    click_button 'Log in'    
    expect(page).to have_content 'Logged in!'
    #Capybara automatically follows any redirects, and submits forms associated with buttons
  end
  
  
  
end

#devel:

#email: vital@farm.ucm.es
#password_hash: $2a$10$RNbZQeJeG617OuzBNnPtN.CZnGe.WkMtsECngTuMcqp3nrT5S.sMa
#password_salt: $2a$10$RNbZQeJeG617OuzBNnPtN.
#created_at: 2013-07-18 15:26:54
#updated_at: 2013-07-18 15:26:54
