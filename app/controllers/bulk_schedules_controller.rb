class BulkSchedulesController < ApplicationController
  before_filter :load_provider
  before_filter :load_studio
  before_filter :authenticate_user!

  def index
    @courses = @studio.courses.where(:event_type => 'recurring')
    @courses = @courses.where('week_day = ? or week_day IS NULL', params[:week_day]) if params[:week_day] && !params[:full_week]
    @courses = @courses.sort_by{|course| course.week_day.to_i}.group_by{|course| course.week_day}
    for wday in (1..7)
      @courses[wday] ||= []
    end
    @courses = @courses.sort_by { |wd, c| wd.to_i }
    @courses.to_a[6], @courses.to_a[0..5] = @courses.to_a[0], @courses.to_a[1..6]
    @room = Room.new
    @studios = @provider.studios.where(:area_id => @area.id)
  end

  def search_by_class
    response = @provider.courses.where("courses.name Like '#{'%' + params[:term] + '%'}'").uniq_by { |c| c.name  }.map {|course| {:label => course.name, :value => course.name, :course_id => course.id}}
    render :js => response.to_json
  end

  def assign_instructor
    Assignment.create(:role_id => 1, :course_id => params[:course_id], :staff_member_id => params[:instructor_id])
    render :nothing => true
  end

  def assign_class
    if params[:current_course]!="0"
      class_name = Course.find(params[:course_id])
      @course = Course.find(params[:current_course])
      @course.update_attributes(
        :name => class_name.name)
        #:room_id => class_name.room_id,
        #:room_temperature_id => class_name.room_temperature_id,
        #:studio_id => @studio.id,
        #:week_day => params[:week_day],
        #:time_span => params[:time_span]
        #);
      @course.styles = class_name.styles
      @course.experience_levels = class_name.experience_levels
      @course.practice_levels = class_name.practice_levels
    else
      course = Course.find(params[:course_id])
      @course = course.clone
      @course.update_attributes(:studio_id => @studio.id, :week_day => params[:week_day], :time_span => params[:time_span]);
      course.price.clone.update_attribute(:course_id, @course.id) if course.price
      @course.styles = course.styles
      @course.experience_levels = course.experience_levels
      @course.practice_levels = course.practice_levels
      render :new_course
    end
  end

  def full_edit
    if params[:course_id]
      @course = Course.find(params[:course_id])
    else
      @course = Course.create(:event_type => 'recurring', :name => params[:class_name], :studio_id => @studio.id, :week_day => params[:week_day], :time_span => params[:time_span])
      @is_new_record = true
    end
    @price = @course.price
  end

  def assign_room
    course = Course.find(params[:course_id])
    course.update_attribute(:room_id, params[:room_id])
    render :nothing => true
  end

  def change_day_of_week
    @courses = @studio.courses.where(:event_type => 'recurring')
    @courses = @courses.where('week_day = ? or week_day IS NULL', params[:week_day]) if params[:week_day]
    @courses = @courses.sort_by{|course| course.week_day.to_i}.group_by{|course| course.week_day}
    @courses[params[:week_day].to_i] ||= [] if params[:week_day]
    if params[:full_week]
      for wday in (1..7) do
        @courses[wday] ||= []
      end
    end
    @courses = @courses.sort_by { |wd, c| wd.to_i }
    @courses.to_a[6], @courses.to_a[0..5] = @courses.to_a[0], @courses.to_a[1..6]
    @room = Room.new
  end

  def update_time_span
    course = Course.find(params[:course_id])
    course.update_attribute(:time_span, params[:time_span])
  end


  def room_search
    response = []
    response = @studio.rooms.where("name Like '#{'%' + params[:term] + '%'}'")
    response = response.map {|room| {:id => room.id, :label => room.name, :value => room.name, :category => ''}}
    response = [{:label => "Create New Room #{params[:term]}", :value => params[:term], :category => 'No suggestions found'}] if response.blank?
    render :js => response.to_json
  end

  def class_search
    response = []
    response = @provider.courses.where("courses.name Like '#{'%' + params[:term] + '%'}'").limit(5).uniq_by { |c| c.name }
    response = response.map {|course| {:id => course.id, :label => course.name, :value => course.name, :wday => course.week_day, :category => ''}}
    response += [{:label => "Create #{params[:term]} as new class", :value => params[:term], :category => 'No suggestions found'}]
    render :js => response.to_json
  end

  def destroy
    Course.find(params[:id]).destroy
  end

end
