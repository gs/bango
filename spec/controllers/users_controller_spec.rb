require 'spec_helper'

describe UsersController do
  render_views

  describe "Get 'index'" do
    describe "for non sign in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end
    describe "for sign in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        Factory(:user, :email => "second@fatbuu.com")
        Factory(:user, :email => "third@fatbuu.com")
        30.times do
          Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should show 'index'" do
        get :index
        response.should be_success
      end

      it "should have a right title" do
        get :index
        response.should have_selector("title", :content => 'All users')
      end

      it "should have an element for each user" do
        get :index
        User.paginate(:page => 1).each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2", :content => "2")
        response.should have_selector("a", :href => "/users?page=2", :content => "Next")
      end

      it "should have a delete links for admins" do
        @user.toggle!(:admin)
        other_user = User.all.second
        get :index
        response.should have_selector("a", :href => user_path(other_user), :content => "delete")

      end

      it "should not have a delete links for admins" do
        other_user = User.all.second
        get :index
        response.should_not have_selector("a", :href => user_path(other_user), :content => 'delete')
      end
    end

  end


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

    it "should show microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "foo bar2")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end

    it "should have pagination" do
      40.times { Factory(:micropost, :user => @user, :content => "foo") }
      get :show, :id => @user
      response.should have_selector("div.pagination")
    end

    it "should have microposts count" do
      10.times { Factory(:micropost, :user => @user, :content => "foo") }
      get :show, :id => @user
      response.should have_selector("td.sidebar", :content => @user.microposts.count.to_s)
      response.should have_selector("td.sidebar", :content => "Microposts")
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

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end


    describe "as a non signed in user" do
      it "should deny access" do
        delete :destroy, :id => @user.id
        response.should redirect_to(signin_path)
      end
    end

    describe "as non-admin user" do
      it "should protect the action" do
        test_sign_in(@user)
        delete :destroy, :id => @user.id
        response.should redirect_to(root_path)
      end
    end

    describe "as admin user" do
      before(:each) do
        @admin = Factory(:user, :email => 'admin@fatbuu.com', :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy user" do
        lambda do
          delete :destroy, :id => @user.id
        end.should change(User, :count).by(-1)
        flash[:notice].should =~ /deleted/i
      end

      it "should to redirect users page" do
        delete :destroy, :id => @user.id
        response.should redirect_to(users_path)
      end

      it "should not allow destroy itself" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count)
      end

    end
  end
end

















