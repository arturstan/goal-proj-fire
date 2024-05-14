require "application_system_test_case"

class GoalCommentsTest < ApplicationSystemTestCase
  setup do
    @goal_comment = goal_comments(:one)
  end

  test "visiting the index" do
    visit goal_comments_url
    assert_selector "h1", text: "Goal comments"
  end

  test "should create goal comment" do
    visit goal_comments_url
    click_on "New goal comment"

    fill_in "Comment", with: @goal_comment.comment
    fill_in "Goal", with: @goal_comment.goal_id
    fill_in "User", with: @goal_comment.user_id
    click_on "Create Goal comment"

    assert_text "Goal comment was successfully created"
    click_on "Back"
  end

  test "should update Goal comment" do
    visit goal_comment_url(@goal_comment)
    click_on "Edit this goal comment", match: :first

    fill_in "Comment", with: @goal_comment.comment
    fill_in "Goal", with: @goal_comment.goal_id
    fill_in "User", with: @goal_comment.user_id
    click_on "Update Goal comment"

    assert_text "Goal comment was successfully updated"
    click_on "Back"
  end

  test "should destroy Goal comment" do
    visit goal_comment_url(@goal_comment)
    click_on "Destroy this goal comment", match: :first

    assert_text "Goal comment was successfully destroyed"
  end
end
