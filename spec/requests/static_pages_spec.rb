require 'spec_helper'

describe "Static pages" do

  subject { page }
  
  describe "Home page" do
    before { visit root_path }
    it { should have_title("colinstodd.com") }
    it { should_not have_title("Home |") }
    it { should have_selector("h2", text: "Welcome to my") }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_title("About") }  
    it { should have_selector("h1", text: "About") } 
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_title("Contact") }
    it { should have_selector("h1", text: "Contact") }
  end

  it "should have the right links on the layout" do 
    visit root_path

    click_link "Sign in"
    page.should have_title("Sign in")

    click_link "Home"
    page.should have_title("colinstodd.com")

    click_link "About"
    page.should have_title("About")

    click_link "Contact"
    page.should have_title("Contact")
  end
  

end
