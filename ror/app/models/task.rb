class Task < ApplicationRecord
  belongs_to :user
  belongs_to :area, optional:true
  belongs_to :project, optional:true
  enum status: [ :inbox, :next, :standalone, :waiting, :schedule_start ]
  enum energy: [ :low, :medium, :high ]
  enum time: [ :FiveMins, :TenMins, :FifteenMins, :TwentyMins, :ThirtyMins, :FortyFiveMins, :OneHour, :OneAndHalfHour, :TwoHours, :ThreeHours, :FourHours, :FiveHours, :SixHours, :EightHours ]
end
