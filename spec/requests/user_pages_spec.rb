require 'spec_helper'

describe "User Pages" do

  subject { page }

  describe "index page" do

    let(:user) { FactoryGirl.create(:user) }

    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }

    before(:each) do
      sign_in user
      visit users_path 
    end

    it { should have_title("All users") }
    it { should have_content("Users") }

    describe "pagination" do
      it { should have_selector("div.pagination") }
  
        it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector("li", text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link("delete") }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do 
          sign_in admin 
          visit users_path
        end

        it { should have_link("delete") }
        it "should be able to delete another user" do 

        end

        before { visit users_path }
        it { should_not have_link("delete", href: user_path(admin))}        
      end      
    end
  end
    
  describe "signup page" do
    before { visit signup_path }
    it { should have_title("Sign up") }
    it { should have_content("Sign up" ) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Year",         with: "2002"
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
        fill_in "Profile Info", with: "Random Info"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving a user" do
        before { click_button submit }

        let(:user) { User.find_by_email("user@example.com") }

        it { should have_title(user.name) }
        it { should have_selector("div.alert.alert-success", text: "Thank's for") }
        it { should have_link("Sign out") }        
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do

      it { should have_title(user.name) }  
      it { should have_selector("h1", text: "Edit profile") }
      it { should have_selector("h2", text: (user.name)) }
      it { should have_link("Change", href: "http://gravatar.com/emails") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content("error") }      
    end

    describe "with valid information" do
      let(:new_year)  { "2005" }
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      let(:pf_info)   { "New Random info" }
      before do
        fill_in "Year",             with: new_year 
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        fill_in "Profile Info",     with: pf_info 
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, title: "tFoo", 
                                   content: "cFoo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, title: "tBar", 
                                   content: "cBar")}

    before { visit user_path(user) }

    it { should have_selector("h1", text: user.name) }

    describe "profile information" do
      it { should have_content("About me:") }
    end

    describe "microposts" do
      it { should have_content(m1.title) }
      it { should have_content(m2.title) }


      it { should have_content(m1.content) }
      it { should have_content(m2.content) }

      it { should have_content(user.microposts.count) }
    end

# FOLLOWING------------------------------------------

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

      end
    end
  end

   describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do 
        sign_in user 
        visit following_user_path(user)
      end

      it { should have_title(full_title("Following")) }
      it { should have_content("Following") }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

  describe "followers" do
    before do 
      sign_in other_user
      visit followers_user_path(other_user)
    end

    it { should have_title(full_title("Followers")) }
    it { should have_content("Followers") }
    it { should have_link(user.name, href: user_path(user)) }
    end
  end

end
