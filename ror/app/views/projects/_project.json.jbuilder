json.extract! project, :id, :user_id, :area_id, :goal_id, :name, :description, :hierarchy, :status, :start_date, :due_date, :star, :created_at, :updated_at
json.url project_url(project, format: :json)
