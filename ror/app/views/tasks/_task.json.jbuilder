json.extract! task, :id, :name, :description, :status, :star, :start_date, :due_date, :energy, :time, :user_id, :area_id, :project_id, :created_at, :updated_at
json.url task_url(task, format: :json)
