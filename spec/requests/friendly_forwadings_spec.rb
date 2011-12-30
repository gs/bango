require 'spec_helper'

describe "FriendlyForwadings" do
    it "should forward the requeste page after signin" do
      user = Factory(:user)
      visit edit_user_path(user)
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button
      response.should render_template("users/edit")
      visit signout_path

      visit signin_path
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button
      response.should render_template("users/show")
    end
end
