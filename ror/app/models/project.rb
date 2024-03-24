class Project < ApplicationRecord
  belongs_to :user
  belongs_to :area, optional:true
  belongs_to :goal, optional:true
end
