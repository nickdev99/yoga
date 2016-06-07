class Room < ActiveRecord::Base
  # Associations
  belongs_to :studio
  has_many   :courses
  has_and_belongs_to_many :temperatures, :class_name => 'RoomTemperature'
  belongs_to :default_temperature, :class_name => 'RoomTemperature'

  # Validations
  validates :name, :presence => true
  validates :capacity, :presence => true, :numericality => true
end
