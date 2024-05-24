class Task < ApplicationRecord
  belongs_to :user
  belongs_to :area, optional:true
  belongs_to :project, optional:true
end
