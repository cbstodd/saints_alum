require 'spec_helper'

describe User do

  # Creates a user example.
  before { @user = User.new(name: "Example User", year: "2002", email: "user@example.com", 
                      password: "foobar", password_confirmation: "foobar",
                      profile_info: "Random info") }
  # Calls the example.                
  subject { @user }

  # Should respond to the User's variables in users/model.  
  it { should respond_to(:name) }
  it { should respond_to(:year) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:profile_info) }

  # Assigns everything below to be_valid unless otherwise specified.
  #  it {should_not be_valid}. Says: in order for the test to be valid,
  #   @user's info needs to check against tests correctly. 
  it { should be_valid }
  it { should_not be_admin }

  describe "accessible attributes" do
    it "should not allow access to admin" do 
      expect do 
        User.new(admin: "1")
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end


  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when year is not present" do
    before { @user.year = " " }
    it { should_not be_valid }
  end

  describe "when year is not an integer" do
    before { @user.year = "a".."z" }
    it { should_not be_valid }
  end

  describe "when year is too long" do
    before { @user.year = 2.to_s * 5 }
  end

  describe "email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }    
  end

  describe "when profile info is empty" do
    before { @user.profile_info = " " }
    it { should_not be_valid }
  end

  describe "when profile info is too long" do
    before { @user.profile_info = "a" * 2001 }
    it { should_not be_valid }
  end

  describe "when year is Invalid" do
    it "should be Invalid" do 
      years = %w[1 '02 98 123 12345 2oo1]
      years.each do |invalid_year|
        @user.year = invalid_year 
        @user.should_not be_valid
      end
    end
  end

  describe "when year is valid" do
    it "should be valid" do 
      years = %w[2001 1949 1920 2016]
      years.each do |valid_year|
        @user.year = valid_year 
        @user.should be_valid
      end
    end
  end

  describe "email format is INvalid" do
    it "should be Valid" do 
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "email format is Valid" do
    it "should be Valid" do 
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
      @user.email = valid_address
      @user.should be_valid 
      end
    end    
  end

  describe "email address with mixed case" do
    let (:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do 
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end    
  end

  describe "when email address is already taken" do
    before do 
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }    
  end

  describe "when password is not present" do
    before do 
      @user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
    end
      it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "Not_foobar" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end


# Authenticate User --------------------------------------

  it { should respond_to(:authenticate) }

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }    
  end

  describe "return value of authenticate method" do
    before { @user.save } # Saves user to database
    let(:found_user) { User.find_by_email(@user.email) }
      # Retrieves email using FBE and assigns it to FU.

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }  
      # @user and FU should be the same, and athenticates it.     
    end

    describe "with invalid password" do 
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      # creates a FU variable whose value is equal to the result of FBE
      it { should_not == user_for_invalid_password }
      # ...it should not be equal to UFIP
      specify { user_for_invalid_password.should be_false } 
      # specify is the same as 'it', and it says it should be false.     
    end    
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
    it "should have a nonblank remember token" do 
      subject.remember_token.should_not be_blank
    end    
  end

#  Microposts...............................................

  describe "microposts associations" do
    before { @user.save }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.dup
      @user.destroy
      microposts.should_not be_empty
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(title: "Title Text",
                                                  content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end       
    end
  end

# FOLLOWERS---------------------------------------------

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do 
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
      
    end
  end


end