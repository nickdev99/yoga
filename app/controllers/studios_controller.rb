class StudiosController < ApplicationController
  before_filter :load_provider
  before_filter :authenticate_user!

  def index
    @studios = @provider.studios.where(:area_id => @area.id)
  end

  def show
    @studio = @provider.studios.find(params[:id])

  end

  def edit
    @studio = @provider.studios.find(params[:id])
    @area = @studio.area
  end

  def new
    @studio = @provider.studios.new
  end

  def update
    @studio = @provider.studios.find(params[:id])

    if @studio.update_attributes(params[:studio])
      @studio.regenerage_slugs
      if params[:details]
        ids = []
        params[:details].each { |i,o|
          ids << i.split('_')[1].to_i
        }
        @studio.details = @studio.details.where(:id => ids)
        (ids - @studio.details.collect(&:id)).each { |i|
          val = params[:details]["detail_#{i}"]
          Detail.create(:studio_id => @studio.id, :name => val[:type], :data => val[:data], :note => val[:note])
        }
      else
        @studio.details = []
      end
      area = Area.find(params[:studio][:area_id])
      redirect_to provider_studios_path(area.city, area.region_abbr, @provider)
    else
      render :edit
    end
  end

  def create
    @studio = @provider.studios.new(params[:studio])

    if @studio.save
      @studio.regenerage_slugs
      if params[:details]
        ids = []
        params[:details].each { |i,o|
          ids << i.split('_')[1].to_i
        }
        ids.each { |i|
          val = params[:details]["detail_#{i}"]
          Detail.create(:studio_id => @studio.id, :name => val[:type], :data => val[:data], :note => val[:note])
        }
      end
      area = Area.find(params[:studio][:area_id])
      redirect_to provider_studios_path(area.city, area.region_abbr, @provider)
    else
      render :new
    end
  end
end
