require "test_helper"

class TaskCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_comment = task_comments(:one)
  end

  test "should get index" do
    get task_comments_url
    assert_response :success
  end

  test "should get new" do
    get new_task_comment_url
    assert_response :success
  end

  test "should create task_comment" do
    assert_difference("TaskComment.count") do
      post task_comments_url, params: { task_comment: { comment: @task_comment.comment, references: @task_comment.references, task: @task_comment.task, user_id: @task_comment.user_id } }
    end

    assert_redirected_to task_comment_url(TaskComment.last)
  end

  test "should show task_comment" do
    get task_comment_url(@task_comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_comment_url(@task_comment)
    assert_response :success
  end

  test "should update task_comment" do
    patch task_comment_url(@task_comment), params: { task_comment: { comment: @task_comment.comment, references: @task_comment.references, task: @task_comment.task, user_id: @task_comment.user_id } }
    assert_redirected_to task_comment_url(@task_comment)
  end

  test "should destroy task_comment" do
    assert_difference("TaskComment.count", -1) do
      delete task_comment_url(@task_comment)
    end

    assert_redirected_to task_comments_url
  end
end
