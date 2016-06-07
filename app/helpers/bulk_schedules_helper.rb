module BulkSchedulesHelper

  def get_temperature room
    if room
      if room.temperatures
        room.temperatures.last.name
      else
        room.default_temperature.name
      end
    end
  end

  def get_difficulty_level course
    cont = ''
    ExperienceLevel.all.each { |level|
      cont += content_tag(:span, nil, :class => course.experience_levels.include?(level) ? 'active' : 'inactive')
    }

    cont.html_safe
  end

  def get_practice_level course
    cont = ''
    PracticeLevel.all.each { |level|
      cont += content_tag(:span, nil, :class => course.practice_levels.include?(level) ? 'active' : 'inactive')
    }

    cont.html_safe
  end

  def day_of_week day
    unless day
      day  = Date.today.wday
    end
    case day.to_i
    when 0
      return 'Sunday'
    when 1
      return 'Monday'
    when 2
      return 'Tuesday'
    when 3
      return 'Wednesday'
    when 4
      return 'Thursday'
    when 5
      return 'Friday'
    when 6
      return'Saturday'
    end
    'DAY'
  end
end
