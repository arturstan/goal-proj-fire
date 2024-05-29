module TasksHelper
  def display_time(time_code)
    case time_code
    when Task::times[:FiveMins]
      '5 mins'
    when Task::times[:TenMins]
      '10 mins'
    when Task::times[:FifteenMins]
      '15 mins'
    when Task::times[:TwentyMins]
      '20 mins'
    when Task::times[:ThirtyMins]
      '30 mins'
    when Task::times[:FortyFiveMins]
      '45 mins'
    when Task::times[:OneHour]
      '1h'
    when Task::times[:OneAndHalfHour]
      '1,5h'
    when Task::times[:TwoHours]
      '2h'
    when Task::times[:ThreeHours]
      '3h'
    when Task::times[:FourHours]
      '4h'
    when Task::times[:FiveHours]
      '5h'
    when Task::times[:SixHours]
      '6h'
    when Task::times[:EightHours]
      '8h'
    end
  end
end
