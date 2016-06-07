class StaffMembersController < ApplicationController
  before_filter :load_provider
  # before_filter :load_studio, :only => :create
  
  def new
    @staff_member = StaffMember.new
    # todo:2: Rails' layout with Proc isn't working
    render :layout => !request.xhr?
  end
  
  def create
    @member = @provider.staff_members.create(params[:staff_member])
    render :text => @member.id
  end
  
  def update_all
    
  end
  
  def show
    @staff_member = @provider.staff_members.find(params[:id])
    # todo:2: Rails' layout with Proc isn't working
    render :layout => !request.xhr?    
  end
end
