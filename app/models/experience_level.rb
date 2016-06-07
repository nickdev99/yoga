# Used to set experience levels for yoga courses.
#
#   course = Course.new
#   course.experience_level = ExperienceLevel.find_by_name('Beginner')
#
# @see Course
class ExperienceLevel < ActiveRecord::Base
  # Validations
  validates :name, :presence => true, :uniqueness => true
end
