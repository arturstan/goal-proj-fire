class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :area, optional:true
end
