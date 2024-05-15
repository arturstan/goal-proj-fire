json.extract! goal_comment, :id, :comment, :user_id, :goal_id, :created_at, :updated_at
json.url goal_comment_url(goal_comment, format: :json)
