# == Schema Information
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#



require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Adam",
              :email => "adam@o2.pl",
              :password => "secret",
              :password_confirmation => 'secret' }
  end
  it "should create user with valid data" do
    User.create!(@attr)
  end

  it "should not create user without name" do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end

  it "should required an email address" do
    no_email_user = User.new(@attr.merge(:email => ''))
    no_email_user.should_not be_valid
  end

  it "should reject name if toooo long" do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[adam@o2.pl ADAM@kokok.co.uk AdAm2@kkkk.com.pl]
    addresses.each  do |email|
      user = User.new(@attr.merge(:email => email))
      user.should be_valid
    end
  end

  it "should not accept invalid email addresses" do
    addresses = %w[adam@o2,pl ADAM_at_kokok.co.uk AdAm2@kkkk.com.]
    addresses.each  do |email|
      user = User.new(@attr.merge(:email => email))
      user.should_not be_valid
    end
  end

  it "should not save duplication email" do
    User.create!(@attr)
    u = User.new(@attr)
    u.should_not be_valid
  end

  it "should not save duplicate in upcase" do
    User.create!(@attr)
    up_email = @attr[:email].upcase
    u = User.new(@attr.merge(:email => up_email))
    u.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have password attribute" do
      @user.should respond_to(:password)
    end

    it "should have password confirmation" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validation" do
    it "should require password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end
    it "should require matching password_confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe "password encryption" do

    before(:each) do
      @user = User.create(@attr)
    end

    it "should have an encryptied password attribute" do
      @user.should respond_to(:encrypted_password)
    end
  end
end

