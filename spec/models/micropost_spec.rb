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
  end
end

