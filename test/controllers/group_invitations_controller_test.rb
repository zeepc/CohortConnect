require 'test_helper'

class GroupInvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_invitation = group_invitations(:one)
  end

  test "should get index" do
    get group_invitations_url
    assert_response :success
  end

  test "should get new" do
    get new_group_invitation_url
    assert_response :success
  end

  test "should create group_invitation" do
    assert_difference('GroupInvitation.count') do
      post group_invitations_url, params: { group_invitation: { accepted?: @group_invitation.accepted?, admin_approved?: @group_invitation.admin_approved?, group_id: @group_invitation.group_id, sent_by_id: @group_invitation.sent_by_id, user_id: @group_invitation.user_id } }
    end

    assert_redirected_to group_invitation_url(GroupInvitation.last)
  end

  test "should show group_invitation" do
    get group_invitation_url(@group_invitation)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_invitation_url(@group_invitation)
    assert_response :success
  end

  test "should update group_invitation" do
    patch group_invitation_url(@group_invitation), params: { group_invitation: { accepted?: @group_invitation.accepted?, admin_approved?: @group_invitation.admin_approved?, group_id: @group_invitation.group_id, sent_by_id: @group_invitation.sent_by_id, user_id: @group_invitation.user_id } }
    assert_redirected_to group_invitation_url(@group_invitation)
  end

  test "should destroy group_invitation" do
    assert_difference('GroupInvitation.count', -1) do
      delete group_invitation_url(@group_invitation)
    end

    assert_redirected_to group_invitations_url
  end
end
