class SchedulesController < ApplicationController
  before_filter :load_provider
  before_filter :load_studio
  before_filter :generate_title

  def index
    wday = params[:wday] ? params[:wday] : Date.today.wday
    @courses = @studio.courses.where(1)
    unless @courses.where(:room_temperature_id => [1,4,5]).blank?
      @hot_available = true
    end
    unless @courses.where(:room_temperature_id => [2,3]).blank?
      @room_temp_available = true
    end
    case params[:filter]
    when 'hot'
      @courses = @courses.where(:room_temperature_id => [1,4,5])
      @style = 'Hot'
    when 'room_temp'
      @courses = @courses.where(:room_temperature_id => [2,3])
      @style = 'Room temp'
    when 'style'
      @courses = @courses.joins(:styles).where("course_styles.cached_slug = ?", params[:style])
      @style = CourseStyle.find(params[:style]).name
    end
    @available_days = @courses.where('(courses.start_date < ? or courses.start_date is null ) and (courses.expiry_date > ? or courses.expiry_date is null)', Date.today + 2.weeks, Date.today).collect(&:week_day).compact.uniq

    @courses = @studio.courses_on(@date) + @courses.where(:week_day => wday).where('(courses.start_date < ? or courses.start_date is null ) and (courses.expiry_date > ? or courses.expiry_date is null)', Date.today + 2.weeks, Date.today)
    case params[:filter]
    when 'less'
      @courses = get_less_60 @courses
      @style = '60 min or less'
    when 'more'
      @courses = get_more_60 @courses
      @style = 'Longer than 60 mins'
    end
    @courses = @courses.group_by { |c|
      if !c.recurring? && c.occurrences.last && c.occurrences.last.start_time
        { :start => c.occurrences.last.start_time, :end => c.occurrences.last.end_time}
      else
        {:start => c.start_time, :end => c.end_time, :label => get_label(c)}
      end
    }.sort_by { |t, c| t[:start] ? t[:start].to_i : 9999 }

    @courses_styles = []
    @studio.courses.each{|m| @courses_styles += m.styles }
    @studios = @provider.studios.where(:area_id => @area.id)
  end

  def show
    @courses = @studio.courses_on(@date) + @studio.courses.where(:week_day => params[:wday])
    @studios = @provider.studios.where(:area_id => @area.id)
    render :partial => 'schedules/show.html', :layout => !request.xhr?
  end

  private

  # please add: if provider has more than 1 studio, show "#{provider.name} #{@studio.name} #{@city} Schedule - I Live Yoga :: All Studios. All Classes."
  # else show "#{@studio.name} #{@city} Schedule - I Live Yoga :: All Studios. All Classes."
  def generate_title
    if @provider.studios.count > 1
      @title = "#{@provider.name} #{@studio.name} #{@city.capitalize} Schedule - I Live Yoga :: All Studios. All Classes."
    else
      @title = "#{@studio.name} #{@city.capitalize} Schedule - I Live Yoga :: All Studios. All Classes."
    end
  end

  def get_label course
    return "New! Class starts on #{course.start_date.strftime("%B %e")}" if course.start_date && course.start_date < Date.today + 2.weeks && course.start_date > Date.today
    return "Last class on #{course.expiry_date.strftime("%B %e")}" if course.expiry_date && course.expiry_date < Date.today + 1.weeks && course.expiry_date > Date.today
  end

  def get_less_60 courses
    courses.select { |c|
      if !c.recurring? && c.occurrences.last && c.occurrences.last.start_time
        c.occurrences.last.end_time.to_i - c.occurrences.last.start_time.to_i <= 60
      else
        c.end_time.to_i - c.start_time.to_i <= 60
      end
    }
  end

    def get_more_60 courses
    courses.select { |c|
      if !c.recurring? && c.occurrences.last && c.occurrences.last.start_time
        c.occurrences.last.end_time.to_i - c.occurrences.last.start_time.to_i > 60
      else
        c.end_time.to_i - c.start_time.to_i > 60
      end
    }
  end

end
