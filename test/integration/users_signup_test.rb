require 'test_helper'

def setup
  ActivationMailer::Base.deliveries.clear
end

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "",
                                      email: "",
                                      password: "",
                                      password_confirmation: ""}
                                }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {name: "Example User",
                                      email: "user@example.com",
                                      password: "foobar",
                                      password_confirmation: "foobar"}
                                }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
        # count # of email
    user = assigns(:user)
        # assigns method is to test instance variable in controller
        # in this case, to test @user
    assert_not user.activated?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: user.email)
        # /account_activations/<token>/edit
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
