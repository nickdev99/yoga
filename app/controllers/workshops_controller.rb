class WorkshopsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @workshops = CourseOccurrence.joins(:course=> :studio).where("studios.area_id = ? and courses.event_type != 'recurring'", @area.id)
    if params[:selected_date]
      @workshops = @workshops.where("course_occurrences.date = ?", params[:selected_date].to_date)
    else
      unless params[:all]
        date = params[:date] ? params[:date].to_date : Date.today
        @workshops = @workshops.where("course_occurrences.date >= ? and course_occurrences.date <= ?", date, date + 6.month)
      else
       @workshops = @workshops.where("course_occurrences.date >= ?", Date.today)
      end
    end
    @workshops = @workshops.order(:date)
    @workshops = @workshops.group_by {|o| o.date}
  end
  
  def show
    @course = Course.find params[:id]
  end
end
