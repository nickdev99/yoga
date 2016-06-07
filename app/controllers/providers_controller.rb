class ProvidersController < ApplicationController
  before_filter :authenticate_user!

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(params[:provider])

    if @provider.save
      redirect_to new_provider_studio_path(@city, @region_abbr, @provider)
    else
      render :new, :alert => "There are errors"
    end
  end

  def update
    @provider = Provider.find(params[:id])
    @provider.update_attributes(params[:provider])
    render :json => {:status => :updated}
  end

  def destroy
    Provider.find(params[:provider_id]).destroy
    redirect_to dashboard_index_path
  end
end
