class CourseStyle < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  # Associations
  has_and_belongs_to_many :courses
end
