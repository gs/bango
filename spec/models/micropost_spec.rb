# == Schema Information
#
# Table name: microposts
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Micropost do
  before(:each) do
    @user = Factory(:user)
    @attr = {:content => "lorem ipsum", :user_id => 1}
  end

  it "should create a micropost with valid content" do
    @user.microposts.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    it "should have the right user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end

    it "should have user" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.microposts.build(:content => " ").should_not be_valid
    end

    it "should reject looong content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end
end

