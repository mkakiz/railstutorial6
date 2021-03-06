require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "",
                                            email: "",
                                            password: "",
                                            password_confirmation: ""
                                           }
                                    }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "foo bar",
                                            email: "foo@bar.com",
                                            password: "",
                                            password_confirmation: ""
                                           }
                                    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "foo bar",  @user.name
    assert_equal "foo@bar.com", @user.email
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    patch user_path(@user), params: { user: { name:  "foo bar",
                                              email: "foo@bar.com",
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "foo bar",  @user.name
    assert_equal "foo@bar.com", @user.email
  end

end
