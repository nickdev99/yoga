class RegistrationsController < Devise::RegistrationsController

  def new
    @areas = Area.where(:active => true)
  end

  def create
    @areas = Area.where(:active => true)
    build_resource
    if resource.valid?
      resource.save
      resource.areas = Area.where(:id => params[:areas]) if params[:user][:is_yoga_teacher] == '1'
      resource.is_yoga_teacher = params[:user][:is_yoga_teacher]
      params[:services].each { |service, value|
        resource.services.create(:name => service) if value != '0'
      }
      sign_in(resource_name, resource)
      Notifier.signup(resource).deliver
      redirect_to dashboard_index_path(@city, @region_abbr)
    else
      clear_passwords_and_redirect
    end
  end

  private
  def clear_passwords_and_redirect
    clean_up_passwords(resource)
    render_with_scope :new
  end
  
end
