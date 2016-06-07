class AssignmentsController < ApplicationController
  before_filter :load_provider
  before_filter :load_studio
  before_filter :load_course
  before_filter :load_occurrence, :except => :remove

  def new
    @assignment = Assignment.new
    # todo:2: xhr layout
    render :layout => !request.xhr?
  end

  # Assigns staff members to courses.
  #
  # Looks in params[:assignment] and expects either of:
  #
  #   1. :staff_member_id - an ID for an existing staff member
  #   2. A hash of :staff_member params, for a new staff member
  #
  # In the first case, the method loads the staff member and assigns
  # them to a course. In the second case, the method first creates
  # the new staff member, then assigns them to a course.
  #
  # In all cases, courses and staff members are scoped to the current provider.
  def create
    assignment_params = params[:assignment]

    if staff_member_id = assignment_params[:staff_member_id]
      @staff_member = @provider.staff_members.find(staff_member_id)
    elsif staff_member_params = assignment_params[:staff_member]
      @staff_member = @provider.staff_members.create!(staff_member_params)
    else
      raise "assignments#create needs a staff member id or params for StaffMember.create!"
    end

    unless @occurrence.staff_members.include? @staff_member
      @occurrence.assignments.create!(:staff_member_id => @staff_member.id)
    end

    # todo:2: xhr layout
    render :action => :index, :layout => !request.xhr?
  end

  def update
    assignment = @occurrence.assignments.find(params[:id])
    assignment.update_attributes(params[:assignment])
    render :action => :index
  end

  def destroy
    assignment = @occurrence.assignments.find(params[:id])
    assignment.destroy
    render :action => :index
  end

  def remove
    @provider.courses.find(params[:course_id]).assignments.delete_all
    redirect_to provider_studio_bulk_schedules_path
  end
end
