class AreasController < ApplicationController
  before_filter :authenticate_user!, :is_admin?, :except => [:area_search]

  def index
    @areas = Area.order(:city)
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(params[:area])

    if @area.save
      redirect_to areas_path
    else
      render :action => 'new'
    end
  end

  def edit
    @area = Area.find(params[:id])
  end

  def update
    @area = Area.find(params[:id])
    if @area.update_attributes(params[:area])
      redirect_to areas_path
    else
      render :action => 'edit', :object => @area
    end
  end

  def destroy
    Area.destroy(params[:id])
    redirect_to areas_path
  end

  def area_search
    response = Area.where("active = 't' and city Like '#{'%' + params[:term] + '%'}'").map {|area| {:label => area.city + ', ' + area.region_abbr.upcase, :value => area.city + ', ' + area.region_abbr.upcase, :area_id => area.id, :city => area.city_slug, :region => area.region_abbr}}
    response = [{:label => 'No suggestions found', :value => params[:term]}] if response.blank?
    render :js => response.to_json
  end

end
