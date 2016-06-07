# Represents a single set of yoga classes.
class Course < ActiveRecord::Base
  # Associations
  belongs_to :studio
  belongs_to :room
  has_and_belongs_to_many :experience_levels
  has_and_belongs_to_many :practice_levels
  belongs_to :room_temperature
  has_many   :occurrences, :class_name => 'CourseOccurrence'
  has_many   :assignments#, :through => :occurrences
  has_many :instructors, :through => :assignments
  has_one    :price, :class_name => 'CoursePrice'#, :dependent => :destroy
  has_and_belongs_to_many :styles, :class_name => 'CourseStyle'

  # Validations
  validates :event_type, :presence => true
  
  # Callbacks
  before_save  :parse_time_span
  after_create :set_first_occurrence
  after_create :set_occurrences
  after_save :remove_occurrences_for_recurring
  
  # Misc
  #
  # Virtual accessor for time span (start time to end time)
  # This lets us use chronic to parse natural language time slots, eg:
  #
  #   time_span  = '11am to noon'
  #   # gives us...
  #   start_time = 11.hours
  #   end_time   = 12.hours
  #
  #attr_accessor :time_span
  
  # See http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html
  accepts_nested_attributes_for :price
  accepts_nested_attributes_for :occurrences
  accepts_nested_attributes_for :assignments

  def initialize(params = {})
    @occurrence_params = params.delete(:occurrences)
    
    super
    
    # Create an associated CoursePrice as soon as the Course
    # is initialized. This lets us use Course#price in courses/new.    
    self.price = CoursePrice.new
  end
  
  def remove_occurrences_for_recurring
    if self.event_type.to_sym == :recurring
      self.occurrences.destroy_all
    end
  end
  
  def staff_members
    occurrences.reload.collect { |o| o.staff_members }.flatten.uniq
  end
  
  # Returns true if event_type == :recurring
  def recurring?
    event_type.to_sym == :recurring
  end
  
  # Returns true if event_type == :single
  def single_date?
    event_type.to_sym == :single
  end
  
  # Returns true if event_type == :multiple
  def multiple_date?
    event_type.to_sym == :multiple
  end
  
  def occurrs_on?(date)
    occurrences.any? { |o| o.date == date }
  end
  
  def room_name
    room.try(:name) || 'Room Name'
  end
  
  def room_temperature_name
    room_temperature.try(:name) || room.try(:default_temperature).try(:name)
  end
    
  # If a room temperature has been given for this specific course,
  # return its ID. Otherwise, return the ID of the temperature of 
  # the Room which this course is associated with.
  #
  # If both Course#room_temperature and Course#room are nil, this
  # method will return nil.
  #
  # @see Room
  def room_temperature_id
    room_temperature.try(:id) || room.try(:temperatures).try(:first).try(:id)
  end
  
  # If a course-specific capacity has been given, return it.
  # Otherwise, return the capacity of the associated Room.
  #
  # If both Course#maximum_capacity and Course#room are nil, this
  # method will return nil.  
  #
  # @see Room
  def maximum_capacity
    read_attribute(:maximum_capacity) || room.try(:capacity)
  end
  
  def first_occurrence
    occurrences.first
  end
  
  private
  # Parses hour values from a time span string.
  #
  #   course.time_span = '11am to 1pm'
  #   course.send :parse_time_span
  #   course.start_time == 11.hours
  #   course.end_time == 13.hours
  # 
  # @see Chronic
  def parse_time_span
    if time_span.present?
      time_span =~ /^([^\s]+)\s+to\s+(.+)$/i
    
      if $1 && $2
        self.start_time =(Chronic.parse($1).hour * 60) + Chronic.parse($1).min
        self.end_time   = (Chronic.parse($2).hour * 60) + Chronic.parse($2).min
      else
        raise "Couldn't properly parse time span: #{time_span.inspect}"
      end
    end
  end
  
  def set_first_occurrence
    occurrences.create!(:date => Date.today) if occurrences.empty?
  end
  
  def set_occurrences
    if @occurrence_params
      case self.event_type
      when :recurring
        unless @occurrence_params.length == 1
          raise "Expected params for one occurrence, got #{@occurrence_params.inspect}"
        end
        
        first_occurrence.update_attributes(@occurrence_params.first)
      end
    end    
  end
end
