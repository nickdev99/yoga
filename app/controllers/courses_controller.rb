class CoursesController < ApplicationController
  include CourseFormHelper
  
  before_filter :load_provider, :except => [:length, :room_temp]
  before_filter :load_studio, :except => [:length, :room_temp]
  before_filter :load_studios, :except => [:length, :room_temp]
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update]
  
  def index
    @courses = Course.all
  end
  
  # Displays the form for a new course
  def new
    @course = @studio.courses.new
    @course.occurrences.build
    @room = Room.new
  end
  
  # Displays edit form
  def edit
    @course = Course.find(params[:id])
    @price = @course.price
    @room = Room.new
  end
  
  def create
    @course = @studio.courses.new(params[:course])
    
    if @course.save
      @course.price.create(params[:price])
      redirect_to provider_studios_path(@city, @region_abbr, @provider)
    else
      render :new
    end
  end
  
  def update
    @course = Course.find(params[:id])
    if @course.event_type == 'single'
      @course.occurrences.first.update_attributes(params[:occurrences])
    elsif @course.event_type == 'multiple'
      occurrences = params[:occurrences].map {|k, v|
        occ = CourseOccurrence.find(k)
        occ.update_attribute(:time_span, v[:time_span])
        occ
      }
      @course.occurrences = occurrences
    end
    if @course.update_attributes(params[:course])
      Course.joins(:studio).where('studios.provider_id = ? and courses.name = ?', @course.studio.provider_id, @course.name).each { |c| c.style_ids = @course.style_ids }
      if @course.price
        @course.price.update_attributes(params[:price])
      else
        @course.price = CoursePrice.create(params[:price])
      end

      respond_to do |format|
        format.js do
        end
        format.html do
          redirect_to schedules_path(@city, @region_abbr, @provider, @studio)
        end
      end
      
    else
      render :edit
    end
  end
  
  def length
    if span = params[:span]
      render :text => Timespan.new(span).length_in_minutes
    else
      raise "Missing :span in params (got #{params.inspect})"
    end
  end

  def instructor_search
    response = []
    response = StaffMember.where("first_name Like '#{'%' + params[:term].split[0] + '%'}' or last_name Like '#{'%' + params[:term].split[0] + '%'}'")
    response = response.where("(first_name Like '#{'%' + params[:term].split[0] + '%'}' and last_name Like '#{'%' + params[:term].split[1] + '%'}') or (first_name Like '#{'%' + params[:term].split[1] + '%'}' and last_name Like '#{'%' + params[:term].split[0] + '%'}')") unless params[:term].split[1].blank?
    response = response.compact.uniq.map {|staff| {:id => staff.id, :label => staff.name(admin?), :value => staff.name(admin?), :category => (staff.providers.blank? || staff.providers.include?(@provider)) ? '' : staff.providers.first.name}}.sort_by{|r| r[:category]}
    response = [{:label => "Create New Profile for #{params[:term]}", :value => params[:term], :category => 'No suggestions found'}] if response.blank?
    render :js => response.to_json
  end

  def new_person
    user = User.find_or_initialize_by_email(params[:user][:email])
    user.attributes = params[:user]
    if user.new_record?
      password = UUID.new.generate(:compact)[3, 10]
      user.password = password
      user.password_confirmation = password
      user.user_type = 0
      Notifier.registration(current_user, user, password).deliver
    end
    user.save!
    @staff = StaffMember.find_or_initialize_by_user_id(user.id)
    @staff.attributes = {:first_name => user.first_name, :last_name => user.last_name}
    @staff.save!
    unless params[:roles].blank?
      Role.create!(params[:roles].map {|key, value| {:name => key}}) do |r|
        r.staff_member_id = @staff.id
        r.provider_id = @provider.id
      end
    end
    if params[:all_studios].blank?
      @staff.studios = Studio.where(:id => params[:studios].collect {|key, value| key.split('_')[1]}) unless params[:studios].blank?
    else
      @staff.studios = @provider.studios
    end
  end

  def room_temp
    render :partial => 'courses/room_temperature', :locals => {:temperatures => Room.find(params[:id]).temperatures}
  end
  
  private
  def render_form_partial
    # next_step = params[:next_step].to_i
    #    
    #    render :partial => form_section_partial(next_step) + '.html',
    #           :layout  => !request.xhr?    
  end

  def load_studios
    @studios = @provider.studios.where(:area_id => @area.id)
  end
end
