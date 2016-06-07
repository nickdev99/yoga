class WidgetController < ApplicationController
  before_filter :authenticate_user!

  def index
    cookies[:"instructor_#{params[:wday]}"] = params[:value] if params[:name_filter] == "instructor"
    cookies[:"coursename_#{params[:wday]}"] = params[:value] if params[:name_filter] == "name"
    cookies[:"location_#{params[:wday]}"] = params[:value] if params[:name_filter] == "location"

    @sunday_temp=[]
    @monday_temp=[]
    @tuesday_temp=[]
    @wednesday_temp=[]
    @thursday_temp=[]
    @friday_temp=[]
    @saturday_temp=[]
    @current_day_begin=[]
    @nday=Time.now.strftime("%w").to_i
    @practice = []

    @instructors = User.where('is_yoga_teacher = "t"')
    @instructors.each do |instructor|
        unless instructor.staff_member.nil?
          if current_user.city
              a=instructor.staff_member.courses.includes(:studio).where('studios.area_id = ? and event_type = "recurring"', @area.id)
              @currents = instructor.staff_member.courses.includes(:studio).where('studios.area_id = ? and event_type = "recurring" and week_day = ?',@area.id,@nday)
          else
              a=instructor.staff_member.courses.includes(:studio).where('event_type = "recurring"')
              @currents = instructor.staff_member.courses.includes(:studio).where('event_type = "recurring" and week_day = ?',@nday)
          end
          @currents.each do |current|
            @current_day_begin << current.attributes.merge('instructor' => instructor.name)
          end
          a.each do |relation|
            b = relation.attributes.merge('instructor' => instructor.name)
            if UserCourse.find_by_course_id_and_user_id(b['id'].to_i,current_user['id'].to_i)
              @practice << b
            end

            if b['week_day'] == 0
                @sunday_temp << b
            end
            if b['week_day'] == 1
              @monday_temp << b
            end
            if b['week_day'] == 2
              @tuesday_temp << b
            end
            if b['week_day'] == 3
              @wednesday_temp << b
            end
            if b['week_day'] == 4
              @thursday_temp << b
            end
            if b['week_day'] == 5
              @friday_temp << b
            end
            if b['week_day'] == 6
              @saturday_temp << b
            end
          end
        end
      end

    cookies.delete :"instructor_#{params[:wday]}" if cookies[:"instructor_#{params[:wday]}"] == 'all_instructors'
    cookies.delete :"coursename_#{params[:wday]}" if cookies[:"coursename_#{params[:wday]}"] == 'all_courses'
    cookies.delete :"location_#{params[:wday]}" if cookies[:"location_#{params[:wday]}"] == 'all_locations'

    @mass_days= Array.new()

    @mass_days.push(:wday => @sunday = day_after_filter(@sunday_temp, cookies[:instructor_1],cookies[:coursename_1],cookies[:location_1]), :wday_temp=>@sunday_temp)
    @mass_days.push(:wday => @monday = day_after_filter(@monday_temp, cookies[:instructor_1],cookies[:coursename_1],cookies[:location_1]), :wday_temp=>@monday_temp)
    @mass_days.push(:wday => @tuesday = day_after_filter(@tuesday_temp, cookies[:instructor_2],cookies[:coursename_2],cookies[:location_2]), :wday_temp=>@tuesday_temp)
    @mass_days.push(:wday => @wednesday = day_after_filter(@wednesday_temp, cookies[:instructor_3],cookies[:coursename_3],cookies[:location_3]), :wday_temp=>@wednesday_temp)
    @mass_days.push(:wday => @thursday = day_after_filter(@thursday_temp, cookies[:instructor_4],cookies[:coursename_4],cookies[:location_4]), :wday_temp=>@thursday_temp)
    @mass_days.push(:wday => @friday = day_after_filter(@friday_temp, cookies[:instructor_5],cookies[:coursename_5],cookies[:location_5]), :wday_temp=>@friday_temp)
    @mass_days.push(:wday => @saturday = day_after_filter(@saturday_temp, cookies[:instructor_6],cookies[:coursename_6],cookies[:location_6]), :wday_temp=>@saturday_temp)



    if params[:wday]
      cookies[:wday]=params[:wday]
      render :layout => false, :locals => {:day_of_week => params[:wday]}
    elsif params[:practice]
      render :layout => false, :locals => {:practice=>true}
    else
      render :layout => false, :locals => {:day_of_week => Time.now.strftime('%w')}
    end
  end

  def day_after_filter day_temp, instructor, coursename, location
    day_temp = day_temp.select{|hash| hash["name"].include? coursename} unless coursename.nil?
    day_temp = day_temp.select{|hash| hash["instructor"].include? instructor} unless instructor.nil?
    day_temp = day_temp.select{|hash| hash["studio_id"].to_s.include? location} unless location.nil?
    day_temp
  end

  def settings
    if params[:check] == 'add'
      unless UserCourse.find_by_course_id_and_user_id(params[:course_id].to_i,current_user[:id].to_i)
        new_rec = UserCourse.new(:user_id => current_user[:id].to_i, :course_id => params[:course_id].to_i)
        new_rec.save
      end
    else
      usercourse = UserCourse.find_by_course_id_and_user_id(params[:course_id].to_i, current_user[:id].to_i)
      usercourse.delete unless usercourse.nil?
    end
      unless params[:practice]
        redirect_to widget_path(:wday=>params[:wday])
      else
        redirect_to widget_path(:practice=>params[:practice])
      end
  end

end

