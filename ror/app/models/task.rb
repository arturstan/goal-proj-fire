class Task < ApplicationRecord
  belongs_to :user
  belongs_to :area, optional:true
  belongs_to :project, optional:true
  enum status: [ :inbox, :next, :standalone, :waiting, :schedule_start ]
  enum energy: [ :low, :medium, :high ]
  enum time: [ :FiveMins, :TenMins, :FifteenMins, :TwentyMins, :ThirtyMins, :FortyFiveMins, :OneHour, :OneAndHalfHour, :TwoHours, :ThreeHours, :FourHours, :FiveHours, :SixHours, :EightHours ]
  validates :name, presence: { message: "Name is required" }
  validates :name, uniqueness: { scope: :project_id, message: "You already have a task with this name and project" }
  validate :start_date_after_now
  validate :due_date_after_start_date
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