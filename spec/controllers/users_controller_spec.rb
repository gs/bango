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

  describe "POST 'create'" do

    describe 'failure' do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end

    describe 'success' do

      before(:each) do
        @attr = { :name => "New user", :email => "user@foobar.com", :password => "foobar", :password_confirmation => "foobar"}
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it 'should redirect to user show page' do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to awesome app/i
      end

     it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
     end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successfull" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have a right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit")
    end

    it "should have a link to change Gravatar" do
      get :edit, :id => @user
      response.should have_selector("a", :href => 'http://gravatar.com/emails',
                                         :content => "Change")
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do
      before(:each) do
        @attr = {:email => "", :name => "", :password_confirmation => ""}
      end

      it "should re-render the page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
    end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Update")
      end

    describe "success" do

      before(:each) do
        @attr = { :name => "New name", :email => "john@fatbuu.com", :password => "fuubarr", :password_confirmation => "fuubarr" }
      end

      it "should change user attributes" do
        put :update, :id => @user, :user => @attr
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
        response.should redirect_to(user_path(@user))
      end

      it "should have flash msg" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "anauthorized access to edit/update" do

    before(:each) do
      @user = Factory(:user)
    end

    describe 'for non signed users' do

      it "should deny to 'edit' action" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /please/i
      end

      it "should deny to 'update' action" do
        put :update, :id => @user.id, :user => {}
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /please/i
      end
    end

    describe 'for sign in users' do
      before(:each) do
        wrong_user = Factory(:user, :email => 'wrong_user@fatbuu.com')
        test_sign_in(wrong_user)
      end

      it "should require matching users for edit" do
        get :edit, :id => @user.id
        response.should redirect_to(root_path)
      end

      it "should require matching users for edit" do
        put :update, :id => @user.id, :user => {}
        response.should redirect_to(root_path)
      end


    end
  end
end

















