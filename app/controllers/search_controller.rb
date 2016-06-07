class SearchController < ApplicationController

  respond_to :js

  def index
    response = []
    response = Studio.limit(10).search(params[:term])
    response += Studio.joins(:provider).limit(10).where("providers.name Like '#{'%' + params[:term] + '%'}'")
    response = response.map {|studio| {:label => (studio.provider.studios.count > 1 ? "#{studio.provider.name} (#{studio.name})" : studio.name), :value => (studio.provider.studios.count > 1 ? "#{studio.provider.name} (#{studio.name})" : studio.name), :href => schedules_path(studio.area.city_slug, studio.area.region_abbr, studio.provider, studio)}}[0..9]
    render :js => response.to_json
  end
  
end
