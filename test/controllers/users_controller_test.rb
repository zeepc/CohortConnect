require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { city: @user.city, current_employer: @user.current_employer, current_title: @user.current_title, first_name: @user.first_name, last_name: @user.last_name, profile_image_url: @user.profile_image_url, profile_link_url: @user.profile_link_url, state: @user.state } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { city: @user.city, current_employer: @user.current_employer, current_title: @user.current_title, first_name: @user.first_name, last_name: @user.last_name, profile_image_url: @user.profile_image_url, profile_link_url: @user.profile_link_url, state: @user.state } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
