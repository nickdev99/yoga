class InstructorsController < ApplicationController
  def index
    @styles = CourseStyle.all
    #@instructors = User.where('is_yoga_teacher = "t"').order('avatar_file_name desc, random()')
    @instructors = User.where('is_yoga_teacher = "t"').randomly_rotate
    @instructors.uniq_by!(&:id)
    @instructors = @instructors.select { |i| i.areas.include?(@area) }
  end

  def show
    @styles = CourseStyle.all
      @style = CourseStyle.find(params[:id])
      #@instructors = User.joins({:staff_member => {:courses => :styles}}).where('is_yoga_teacher = "t" and course_styles.cached_slug = ?', params[:id]).order('random()')
      @instructors = User.joins({:staff_member => {:courses => :styles}}).where('is_yoga_teacher = "t" and course_styles.cached_slug = ?', params[:id]).randomly_rotate
    @instructors = @instructors.select {|i| i.is_featured && (i.featured_date.nil? || i.featured_date > Date.today)}.sort_by { rand } + @instructors
    @instructors.uniq_by!(&:id)
    @instructors = @instructors.select { |i| i.areas.include?(@area) }
    
    render :index
  end

  def destroy
    Assignment.find(params[:id]).destroy
  end

  def profile
    hash = Hash.new { |h, key| h[key] = {} }
    
    @instructor = User.find(params[:username])
    @areas = @instructor.areas
    @area = Area.where(:city_slug => params[:city]).first
    @area = @instructor.areas.first unless @area
    @instructor.staff_member.courses.includes(:studio).where('studios.area_id = ? and event_type = "recurring"', @area.id).each { |c|
      if hash[c.studio][c.week_day.to_i]
        hash[c.studio][c.week_day.to_i] += [c]
      else
        hash[c.studio][c.week_day.to_i] = [c]
      end
      }
    @courses = hash
    @workshops = CourseOccurrence.joins([{:course => :assignments}]).where("courses.event_type != 'recurring' and course_occurrences.date > ? and assignments.staff_member_id = ?", Date.today, @instructor.staff_member.id)
    @teaching = CourseStyle.joins(:courses => [:instructors, :studio]).where('studios.area_id = ? and staff_members.id = ?', @area.id, @instructor.staff_member.id).uniq
    @title = "#{@instructor.name} - Yoga Instructor #{@area.city.capitalize} :: I Live Yoga :: All Studios. All Classes."
  end
end
