# Represents a single occurrence of a yoga class.
#
# Each course can have one or more occurrences. Each occurrence of
# a course represents a particular date and time on which the course
# will take place, and each occurrence can be associated with different
# staff members, different rooms, etc.
class CourseOccurrence < ActiveRecord::Base
  # Associations
  belongs_to :course
  has_many :assignments
  has_many :staff_members, :through => :assignments

  # Callbacks
  before_create :set_time_span
  before_update :set_time_span
  
  # Misc
  #
  # Store the time_span in the database
  # as a Timespan object.
  #
  # @see Timespan
  #serialize :time_span, Timespan
  
  # The model uses this virtual attribute
  # to convert :time_span => '11am to noon'
  # to a Timespan.
  #
  # @see #initialize
  # @see #update_attributes
  # @see #update_attribute
  attr_accessor :span
  
  # Convert :time_span => '10am to 11am'
  # to a Timespan when a new object is
  # intialized.
  # def initialize(params = {})
  #   self.span = params.delete(:time_span)
  #   super
  # end

  # Convert :time_span => '10am to 11am'
  # to a Timespan when attributes are updated.
  # def update_attributes(params = {})
  #   self.span = params.delete(:time_span)
  #   super
  # end
  
  # Convert :time_span => '10am to 11am'
  # to a Timespan when an attribute is updated.
  # def update_attribute(name, value)
  #   self.span = value if name.to_sym == :time_span
  #   super
  # end
  # 
  # def start_time
  #   time_span.start_time
  # end
  # 
  # def end_time
  #   time_span.end_time
  # end
  
  private
  def set_time_span
    if self.time_span.present?
      self.time_span =~ /^([^\s]+)\s+to\s+(.+)$/i

      if $1 && $2
        self.start_time =(Chronic.parse($1).hour * 60) + Chronic.parse($1).min
        self.end_time   = (Chronic.parse($2).hour * 60) + Chronic.parse($2).min
      else
        raise "Couldn't properly parse time span: #{time_span.inspect}"
      end
    end
  end
end
