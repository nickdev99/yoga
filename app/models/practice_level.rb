# Used to set practice levels for yoga courses.
#
#   course = Course.new
#   course.practice_level = PracticeLevel.find_by_name('Gentle')
#
# @see Course
class PracticeLevel < ActiveRecord::Base
  # Validations
  validates :name, :presence => true, :uniqueness => true
end
