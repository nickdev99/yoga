# Represents a single Analytics event: a page view.
#
# Collections of Events are grouped under Analytics::Episodes,
# which in turn belong to a particular user. This lets us collect
# data on which pages a user is viewing and (via database timestamps)
# what order the pages are being viewed in.
class Analytics::Event < ActiveRecord::Base
  include LocalEngine::Analytics::UUID
  
  set_table_name 'analytics_events'
  
  # Associations
  belongs_to :episode, :class_name => 'Analytics::Episode'
  
  # Callbacks
  before_create :set_uuid
  before_create :set_default_empty_data
  
  # Misc
  #
  # Serializing the event data lets us store whatever data
  # we like in a hash, without running new migrations. For example, 
  # we could start storing event length:
  # 
  #   event.data[:length] = 1.hour # or whatever
  #
  # @see Event#[](key, value)
  # @see Event#[](key)
  serialize :data, Hash
  
  class << self
    # Creates a new page view event using
    # information from a request object.
    #
    # @param [ActionController::Request] request The request obect
    # @return [Analytics::Event] a new event
    # @raise [ActiveRecord::RecordNotSaved] if create callbacks fail
    # @see ActiveRecord::Base#save!
    def create_from_request!(request)
      url = request.url
      ip  = request.remote_ip
      xhr = request.xhr?
      
      create!(:data => {:url => url, :ip => ip, :xhr => xhr})
    end
  end
  
  # Convenience method to store data.
  #
  #   # Equivalent to event.data[:url] = 'example.com'
  #   event[:url] = 'example.com'
  #
  # @param [Symbol] key
  # @param [Object] value
  def [](key, value)
    data[key] = value
  end
  
  # Convenience method to retrieve data.
  #
  #   # Equivalent to event.data[:url].
  #   event[:url] # => 'example.com'
  #
  # @param [Symbol] key
  def [](key)
    data[key]
  end
  
  private
  # Sets an event's +data+ attribute to an empty hash by default.
  # Will not overwrite existing data.
  def set_default_empty_data
    self.data ||= {}
  end
end
