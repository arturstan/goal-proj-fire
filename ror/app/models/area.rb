class Area < ApplicationRecord
  belongs_to :user
  validates :name, presence: { message: "Name is required" }
  validates :name, uniqueness: { scope: :user_id, message: "You already have an area with this name" }

  # other code...
end
