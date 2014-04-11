require 'spec_helper'

describe User do

  # Creates a user example.
  before { @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar") }
  # Calls the example.                
  subject { @user }

  # Should respond to the User's variables.  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  # Assigns everything below to be_valid unless otherwise specified.
  # says: in order for the test to be valid,
  #   @user's info needs to check against tests correctly. 
  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }    
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
end