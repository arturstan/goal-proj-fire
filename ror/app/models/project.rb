class Project < ApplicationRecord
  enum status: [ :active, :suspended, :scheduled, :someday, :archived ]
  belongs_to :user
  belongs_to :area, optional:true
  belongs_to :goal, optional:true
  has_many :project_comments
  has_many :tasks
  validates :name, presence: { message: "Name is required" }
  validates :name, uniqueness: { scope: :user_id, message: "You already have an area with this name" }
  validate :start_date_after_now
  validate :due_date_after_start_date
  has_and_belongs_to_many :tags

  private

  def start_date_after_now
    if start_date.nil?
      return
    end
    if start_date < Date.today
      errors.add(:start_date, "should be after or equal today")
    end
  end

  def due_date_after_start_date
    if start_date.nil? || due_date.nil?
      return
    end
    if due_date < start_date
      errors.add(:due_date, "should be after than due date")
    end
  end
end
