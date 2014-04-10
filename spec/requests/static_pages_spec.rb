require 'spec_helper'

describe "Static pages" do

  subject { page }
  
  describe "Home page" do
    before { visit root_path }
   it { should have_content("Welcome to my") }
   it { should have_title("colinstodd.com") }
   it { should_not have_title("Home |") }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_content("About") }
    it { should have_title("About") }   
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_content("Contact") }
    it { should have_title("Contact") }
  end

  
end
