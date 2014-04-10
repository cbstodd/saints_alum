require 'spec_helper'

describe "Static pages" do
  
  describe "Home page" do
    it "should have the content 'ColinStodd.com'" do 
      visit '/static_pages/home'
      expect(page).to have_content("ColinStodd.com")
    end   

    it "should have the title 'ColinStod.com'" do 
      visit '/static_pages/home'
      expect(page).to have_title("ColinStodd.com")
    end
  end

  describe "About page" do
    it "should have the content 'About'" do 
      visit '/static_pages/about'
      expect(page).to have_content("About")
    end

    it "should have the title 'About'" do 
      visit '/static_pages/about'
      expect(page).to have_title("About")
    end    
  end

  describe "Contact page" do
    it "should have the content 'Contact'" do 
      visit 'static_pages/contact' 
      expect(page).to have_content("Contact")
    end

    it "should have the title 'Contact'" do 
      visit 'static_pages/contact' 
      expect(page).to have_title("Contact")
    end    
  end

  
end
