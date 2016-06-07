# Stores information about the role for a particular Assignment
# People can be assigned to a course as instructors, assistants, etc.
class AssignmentRole < ActiveRecord::Base
  # Validations
  validates :name, :presence => true, :uniqueness => true
end
