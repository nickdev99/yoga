class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = User.find(params[:id])
    @services = @user.services.collect(&:name)
    @areas = Area.where(:active => true)
    @selected_areas = @user.areas
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    @user.areas = Area.where(:id => params[:areas]) if params[:user][:is_yoga_teacher] == '1'
    @user.is_yoga_teacher = params[:user][:is_yoga_teacher]
    @user.avatar = params[:user][:avatar] unless params[:user][:avatar].blank?
    if @user.valid?
      @user.save!
      @user.update_staff
      @user.regenerage_slugs
      params[:services].each { |service, value|
        if value != '0'
          @user.services.find_or_create_by_name(service)
        else
          serv = @user.services.find_by_name(service)
          unless serv.nil?
            serv.destroy
          end
        end
      }
      redirect_to dashboard_index_path(@city, @region_abbr)
    else
      flash[:alert] = "#{@user.errors.to_a.join('\n')}"
      redirect_to edit_profile_path(@user)
    end
  end

end
