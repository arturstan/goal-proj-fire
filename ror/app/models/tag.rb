class Tag < ApplicationRecord
  belongs_to :user
  validates :name, presence: { message: "Name is required" }
  validates :name, uniqueness: { scope: :user_id, message: "You already have an area with this name" }
  has_and_belongs_to_many :projects

end
