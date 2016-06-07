module WidgetHelper
  def name_day_of_week day
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

  def get_city studio_id
    return Area.where(:id => (Studio.find_by_id(studio_id)).area_id).first.city
  end

  def get_uniq_rec(arr,key)
    a = []
    arr.each do |course|
      unless a.include? course[:"#{key}"]
        a << course[:key]
        res << "<li><a href='#'>#{course[:"#{key}"]}</a></li>"
      end
    end
    res
  end
end
