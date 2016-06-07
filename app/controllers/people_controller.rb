class PeopleController < ApplicationController
  before_filter :load_provider, :except => [:all, :remove]
  before_filter :load_studio, :only => :create
  before_filter :authenticate_user!

  def index
    @people = @provider.staff_members.joins(:studios).where('studios.area_id = ?', @area.id)
    @people.joins(:roles).where('roles.name = ?', params[:role]) if params[:role] && params[:role] != 'all'
    @people.uniq!
  end

  def all
    if params[:role] && !params[:admin]
      @people = StaffMember.joins([:roles, :studios]).where('roles.name = ? and studios.area_id = ?', params[:role], @area.id)
    else
      @people = StaffMember.where(1)
      @people = @people.joins(:studios).where('studios.area_id = ?', @area.id) unless params[:admin]
    end
    @people = @people.delete_if { |s| s.roles.blank? && s.studios.blank? }.uniq unless params[:admin]
    render :index
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
    @roles = @user.staff_member.roles.collect(&:name)
    @studios = @user.staff_member.studios.collect(&:id)
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    @user.save!
    @user.staff_member.update_attributes({:first_name => @user.first_name, :last_name => @user.last_name})
    if params[:all_studios].blank?
      @user.staff_member.studios = Studio.where(:id => params[:studios].collect {|key, value| key.split('_')[1]}) unless params[:studios].blank?
    else
      @user.staff_member.studios = @provider.studios
    end
    redirect_to :action => :index
  end

  def create
    @user = User.find_or_initialize_by_email(params[:user][:email])
    @user.attributes = params[:user]
    if @user.new_record?
      password = UUID.new.generate(:compact)[3, 10]
      @user.password = password
      @user.password_confirmation = password
      @user.user_type = 0
      Notifier.registration(current_user, @user, password).deliver
    end
    @user.save!
    staff = StaffMember.find_or_initialize_by_user_id(@user.id)
    staff.attributes = {:first_name => @user.first_name, :last_name => @user.last_name}
    staff.save!
    @provider.staff_members << staff unless @provider.staff_members.include?(staff)
    if params[:assign_instructor] == "true"
      assignment = Assignment.new
      assignment.course_id = params[:course_id].to_i
      assignment.staff_member_id = staff.id
      assignment.role_id = 1
      assignment.save!
    end
    unless params[:roles].blank?
      Role.create!(params[:roles].map {|key, value| {:name => key}}) do |r|
        r.staff_member_id = staff.id
        r.provider_id = @provider.id
      end
    end
    if params[:all_studios].blank?
      staff.studios = Studio.where(:id => params[:studios].collect {|key, value| key.split('_')[1]}) unless params[:studios].blank?
    else
      staff.studios = @provider.studios
    end

    redirect_to provider_studio_bulk_schedules_path(@city, @region_abbr, @provider, @studio)
    #redirect_to provider_people_path(@city, @region_abbr, @provider)
  end

  def destroy
    @provider.staff_members.delete(StaffMember.find(params[:id]))
  end

  def remove
    person = StaffMember.find(params[:id])
    person.studios = []
    person.roles = []
  end

  def email_search
    response = User.where("email Like '#{'%' + params[:term] + '%'}'").map {|user| {:label => user.email, :value => user.email, :first_name => user.first_name, :last_name => user.last_name}}
    response = [{:label => 'No suggestions found', :value => params[:term], :category => "Products"}] if response.blank?
    render :js => response.to_json
  end

  def first_name_search
    response = User.where("first_name Like '#{'%' + params[:term] + '%'}'").map {|user| {:label => user.name(admin?), :value => user.first_name, :email => user.email, :last_name => user.last_name}}
    response = [{:label => 'No suggestions found', :value => params[:term]}] if response.blank?
    render :js =>  response.to_json
  end

  def last_name_search
    response = User.where("last_name Like '#{'%' + params[:term] + '%'}'").map {|user| {:label => user.name(admin?), :value => user.last_name, :first_name => user.first_name, :email => user.email}}
    response = [{:label => 'No suggestions found', :value => params[:term]}] if response.blank?
    render :js => response.to_json
  end
end
