# Represents a single Analytics 'session' (in other words, the time 
# between a user coming to the website and the user leaving the website).
#
# Each Episode belongs to a single user and has many Events, which represent
# visits to a particular page.
#
# Not named "Analytics::Session" to avoid conflicts (Rails uses "Session" a lot).
class Analytics::Episode < ActiveRecord::Base
  include LocalEngine::Analytics::UUID
  
  set_table_name 'analytics_episodes'
  
  # Associations
  has_many :events, :class_name => 'Analytics::Event'
  
  # Callbacks
  before_create :set_uuid
  
  def add_event(request)
    events << Analytics::Event.create_from_request!(request)
  end
end
