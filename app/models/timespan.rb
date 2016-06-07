require 'chronic'

# Used to create, parse, and store time spans: periods of time
# like 10am and 11m. Not an active record model.
class Timespan
  # Use ActiveCallbacks to set length on create
  extend ActiveModel::Callbacks
  define_model_callbacks :create
  
  # Callbacks
  after_create :parse_span
  
  # Attributes
  attr :span
  attr :length
  attr :start_time
  attr :end_time
  
  def initialize(span)
    @span   = span
    @length = 0
    
    _run_create_callbacks
  end
  
  def length_in_words
    hours = @end_time.hour - @start_time.hour
    mins  = @end_time.min - @start_time.min

    hours_label = hours > 1 ? 'hours' : 'hour'
    
    if mins == 0
      "#{hours} #{hours_label}"
    else
      "#{hours} #{hours_label} #{mins} minutes"
    end
  end

  def length_in_minutes
    "#{(@length/60).to_i} mins"
  end
  
  private
  def parse_span
    if @span.present?
      @span =~ /^([^\s]+)\s+to\s+(.+)$/i
    
      if $1 && $2
        @start_time = Chronic.parse($1)
        @end_time   = Chronic.parse($2)
        @length     = (@end_time - @start_time)
      else
        raise "Couldn't properly parse time span: #{@span.inspect}"
      end
    end
  end
end
