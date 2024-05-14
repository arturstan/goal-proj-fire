require "test_helper"

class GoalCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @goal_comment = goal_comments(:one)
  end

  test "should get index" do
    get goal_comments_url
    assert_response :success
  end

  test "should get new" do
    get new_goal_comment_url
    assert_response :success
  end

  test "should create goal_comment" do
    assert_difference("GoalComment.count") do
      post goal_comments_url, params: { goal_comment: { comment: @goal_comment.comment, goal_id: @goal_comment.goal_id, user_id: @goal_comment.user_id } }
    end

    assert_redirected_to goal_comment_url(GoalComment.last)
  end

  test "should show goal_comment" do
    get goal_comment_url(@goal_comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_goal_comment_url(@goal_comment)
    assert_response :success
  end

  test "should update goal_comment" do
    patch goal_comment_url(@goal_comment), params: { goal_comment: { comment: @goal_comment.comment, goal_id: @goal_comment.goal_id, user_id: @goal_comment.user_id } }
    assert_redirected_to goal_comment_url(@goal_comment)
  end

  test "should destroy goal_comment" do
    assert_difference("GoalComment.count", -1) do
      delete goal_comment_url(@goal_comment)
    end

    assert_redirected_to goal_comments_url
  end
end
