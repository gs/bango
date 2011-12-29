require 'spec_helper'

describe UsersController do
  render_views

  describe "Get 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be success" do
      get :show, :id => @user
      response.should be_success
    end

    it "should assign user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have correct title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should have user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have an image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end

    it "should have correct url" do
      get :show, :id => @user
      response.should have_selector("td>a", :content => user_path(@user),
                                            :href => user_path(@user))

    end
  end


  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should have title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
  end

end
