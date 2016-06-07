# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  # Use custom RSpec matchers from spec/support/custom_matchers.rb
  config.include YogaSite::CustomMatchers
end

# Default timespan should be simple and easy to parse
def new_timespan(span = '10am to 11am')
  Timespan.new(span)
end

# todo:1: rename new_course => create_course
def new_course(options = {})
  options = {
    # start and end times should be calculated by the model
    :event_type => :recurring, 
    :week_days  => [1],
    :name       => 'My Class'
  }.merge!(options)
  
  Course.create!(options)
end

def complete_and_valid_course_params
  @complete_and_valid_course_params ||= {
    :event_type => :recurring,
    :name => "Course Submitted At #{Time.now}",
    :week_days => [1],
    :time_span => '10am to 11am',
    :room_id  => @studio.rooms.first.id,
    :room_temperature_id => room_temperatures(:warm).id,
    :minimum_capacity => 10,
    :maximum_capacity => 25,
    :experience_level_id => experience_levels(:beginner).id,
    :practice_level_id => practice_levels(:gentle).id,
    :description => 'A nice gentle course',
    :notice => 'Look at this notice',
    :information_link => 'www.example.com/yoga',
    :staff_tba => true,
    :rotational_instructor => true,
    # Nested attributes for course.price
    :price => {
      :cost_type => :donation,
      :minimum_donation => 10
    },
    :pre_registration_required => true,
    :registration_form_link => 'www.example.com/yoga/form',
    :registration_email => 'yoga@example.com',
    :registration_phone_number => '1234567890'
  }
end