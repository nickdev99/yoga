class AmbassadorsController < ApplicationController
  before_filter :authenticate_user!, :is_admin?

  def index
    @ambassadors = User.where(:ambassador => true)
    @areas = Area.where(:active => true)
  end

  def show
    @areas = Area.where(:active => true)
    user = User.find(params[:id])
    user.update_attribute(:ambassador, true)
    user.cities = Area.where(:id => params[:areas].split(','))
    render :partial => 'ambassador_row', :locals => {:amb => user}
  end

  def assign_areas
    ambassador = User.find params[:id]
    ambassador.cities = Area.where(:id => params[:areas])
    render :nothing => true
  end

  def search
    response = []
    response = User.where(:ambassador => false).where("first_name Like '#{'%' + params[:term].split[0] + '%'}' or last_name Like '#{'%' + params[:term].split[0] + '%'}'")
    response = response.where("(first_name Like '#{'%' + params[:term].split[0] + '%'}' and last_name Like '#{'%' + params[:term].split[1] + '%'}') or (first_name Like '#{'%' + params[:term].split[1] + '%'}' and last_name Like '#{'%' + params[:term].split[0] + '%'}')") unless params[:term].split[1].blank?
    response = response.compact.uniq.map {|user| {:id => user.id, :label => user.name(admin?), :value => user.name(admin?)}}
    response = [{:label => "No suggestions found", :value => params[:term]}] if response.blank?
    render :js => response.to_json
  end

  def destroy
    user = User.find(params[:id])
    user.update_attribute(:ambassador, false)
    user.cities = []
  end
end
