class Goal < ApplicationRecord
  enum status: [ :active, :important, :suspended, :someday, :archived ]
  belongs_to :user
  belongs_to :area, optional:true
  validates :name, presence: { message: "Name is required" }
  validates :name, uniqueness: { scope: :user_id, message: "You already have an area with this name" }

end
