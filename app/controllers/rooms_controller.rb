class RoomsController < ApplicationController
  before_filter :load_provider
  before_filter :load_studio
  before_filter :authenticate_user!, :only => [:new, :edit, :update, :create]

  def show
    render :json => @studio.rooms.find(params[:id]), :include => [:studio, :temperatures]
  end

  def new
    @room = @studio.rooms.new
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])

    @room.update_attributes(params[:room])
    redirect_to provider_studios_path(@city, @region_abbr, @provider)
  end

  def create
    @room = @studio.rooms.new(params[:room])
    if @room.save
      params[:room][:temperature_ids].reject { |id| !id.kind_of? Integer }.each do |id|
        temp = RoomTemperature.find(id)
        unless @room.temperatures.include? temp
          @room.temperatures << temp
        end
      end
      respond_to do |format|
        format.js do
        end
        format.html do
          redirect_to provider_studios_path(@city, @region_abbr, @provider)
        end
      end
    else
      render :new
    end
  end
end
