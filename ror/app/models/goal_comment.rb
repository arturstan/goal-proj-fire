class GoalComment < ApplicationRecord
  belongs_to :user
  belongs_to :goal
end
