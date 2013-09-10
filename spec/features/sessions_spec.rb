require 'spec_helper'

#note: Feature and scenario are a part of Capybara, and not rspec, and are meant to be used for acceptance and integration tests

feature "success" do
  background do
    visit new_session_path
    user = FactoryGirl.create(:user)
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Log in'
  end
  
  scenario "displays welcome message" do
    expect(page).to have_content "logged in as"
  end
  
  scenario "shows the correct navigation links" do
    within('nav_links') do
     expect(page).to have_link('log out')
    end
    within('content') do
      expect(page).to have_link('Experiments')
      expect(page).to have_link('MzidFiles')
    end
  end
  
  
end
