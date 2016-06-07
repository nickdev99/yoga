module SchedulesHelper
  def link_to_schedule_date(date)
    text  = date.strftime('%A')
    
    link_to text,
      schedules_path(@city, @region_abbr, :wday => date.wday, :filter => params[:filter], :style => params[:style]),
      :class  => 'schedule_date', :style => ((date.wday.to_s == params[:wday]) || (date.today? && params[:wday].blank?) ) ? 'background: #00D500; color: white' : ''
  end
end
