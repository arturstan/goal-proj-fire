class Project < ApplicationRecord
  enum status: [ :active, :suspended, :scheduled, :someday, :archived ]
  belongs_to :user
  belongs_to :area, optional:true
  belongs_to :goal, optional:true
  validates :name, presence: true
end
