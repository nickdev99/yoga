# Represents an assignment of a staff member to a course occurrence.
#
# For example, given a course "c" with 1 occurrence, we might assign
# a staff member to the course via:
#
#   c.occurrences.first.assignments.create(staff_member_params)
#
# @see CourseOccurrence
class Assignment < ActiveRecord::Base
  # Associations
  belongs_to :course
  belongs_to :course_occurrence
  belongs_to :staff_member
  belongs_to :instructor, :class_name => 'StaffMember', :foreign_key => :staff_member_id
  belongs_to :role, :class_name => 'AssignmentRole'
  
  # Callbacks
  before_save :set_default_role
  
  private
  def set_default_role
    self.role ||= AssignmentRole.find_by_name('Instructor')
  end
end
