require 'digest/sha1'
require 'local_engine'

class ApplicationController < ActionController::Base
  protect_from_forgery
  analytical :modules=>[:console, :google]

  require File.join(Rails.root, 'lib', 'local_engine.rb')
  
  # LocalEngine analitics
  include LocalEngine::Analytics::Filters
  before_filter :setup_analytics
  before_filter :load_area
  after_filter  :record_analytics_event
  helper_method :admin?, :is_ambassador?
  
  # Adds additional HTTP authentication to the
  # dev.iliveyoga.ca version of the website.
  # before_filter :authenticate_staging_site
  
  # Digest versions of username and password
  #
  # To generate these, use:
  #
  #   require 'digest/sha1'
  #   Digest::SHA1.hexdigest('user_name_or_password')
  #
  # Never store passwords in the plain sight.
  # USERNAME = '0b64fcf50936a13fc4a4e8f5703a25aa012f16d7'
  # PASSWORD = 'ada1fc9b9a5a5e4e0babf6d51f0c768198e69d5e'
    
  private
  def load_provider
    @provider = Provider.find(params[:provider_id])
  end

  def load_area
    if cookies[:area] && !params[:city]
      @area = Area.find(cookies[:area])
    else
      @area = Area.where(:city_slug => params[:city].downcase, :region_abbr => params[:region_abbr].downcase).first if params[:city] && params[:region_abbr]
    end
    @area = Area.first if @area.nil?
    cookies[:area] = @area.id
    @city = @area.city_slug
    @region_abbr = @area.region_abbr
  end

  def load_studio
    @studio = @provider.studios.find(params[:studio_id])
  end

  def load_course
    @course = @studio.courses.find(params[:course_id])
  end
  
  def load_occurrence
    @occurrence = @course.occurrences.find(params[:course_occurrence_id])
  end

  def is_admin?
    redirect_to new_user_session_path unless admin?
  end

  def admin?
    return false unless current_user
    current_user.admin?
  end

  def is_ambassador?
    return true if(current_user && (current_user.admin? || (current_user.ambassador? && current_user.cities.include?(@area))))
    false
  end

  # def authenticate_staging_site
  #   # Authenticate with HTTP basic authentication.
  #   #
  #   # todo:1: use a separate staging environment
  #   #
  #   # A separate staging environment would be useful here;
  #   # currently we're treating the staging environment as
  #   # production for the purposes of HTTP authentication
  #   if Rails.env.production? && !request.xhr?
  #     authenticate_or_request_with_http_basic do |username, password|
  #       hex(username) == USERNAME && hex(password) == PASSWORD
  #     end
  #   end
  # end
  
  def hex(string)
    Digest::SHA1.hexdigest(string)
  end 
  
end
