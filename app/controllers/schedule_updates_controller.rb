class ScheduleUpdatesController < ApplicationController
  before_filter :load_provider
  before_filter :load_studio
  before_filter :authenticate_user!

  def index
    @courses = Hash.new { |h,k| h[k]=[] }
    courses_with_start_date = @studio.courses.where('start_date IS NOT NULL')
    courses_with_start_date = courses_with_start_date.where('start_date = ?', params[:date].to_date) if params[:date]
    courses_with_expiry_date = @studio.courses.where('expiry_date IS NOT NULL')
    courses_with_expiry_date = courses_with_expiry_date.where('expiry_date = ?', params[:date].to_date) if params[:date]
    @courses = merge_hash @courses, courses_with_start_date.group_by{|course| course.start_date }
    @courses = merge_hash @courses, courses_with_expiry_date.group_by{|course| course.expiry_date }
    @courses = @courses.sort_by {|d, c| d}
    @studios = @provider.studios.where(:area_id => @area.id)
  end

  def merge_hash hash, other_hash
    other_hash.each { |key, value|  
      hash[key] += value
    }
    
    hash
  end
end
