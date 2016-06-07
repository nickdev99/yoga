class CourseOccurrencesController < ApplicationController
  before_filter :load_provider, :only => [:new, :create, :destroy]
  before_filter :load_studio, :only => [:new, :create, :destroy]
  before_filter :load_course, :only => [:new, :create, :destroy]
  
  # todo:3: we may not need this action
  def new
    @occurrence = @course.occurrences.new
    
    render :layout => !request.xhr?
  end
  
  def create
    @occurrence      = @course.occurrences.new
    @occurrence.date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
        
    case params[:event_type]
    when 'single'
      # Make sure there's only one occurrence for single date events
      @course.occurrences.clear if params[:event_type] == 'single'

      if @occurrence.save
        render :action => :show, :layout => !request.xhr?
      end
    when 'multiple'
      if @occurrence.save
        render :action => :index, :layout => !request.xhr?
      end
    end
  end
  
  def update
    @occurrence = CourseOccurrence.find(params[:id])
    @occurrence.time_span = params[:span]
    @occurrence.save!
    render :json => @occurrence
  end
  
  def destroy
    # Previous calls to #create may have cleared a course's
    # occurrences, so only try to destroy an occurrence
    # if it still exists.
    occurrence = @course.occurrences.find_by_id(params[:id])
    occurrence.destroy if occurrence
    render :action => :index, :layout => !request.xhr?    
  end
end
