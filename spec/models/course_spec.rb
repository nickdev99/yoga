require 'spec_helper'

describe Course do
  
  fixtures :all
  
  it {
    # Associations
    should belong_to :studio
    should belong_to :room
    should have_and_belong_to_many :experience_levels
    should have_and_belong_to_many :practice_levels
    should have_many :occurrences
    should have_many(:assignments).through(:occurrences)
    should have_one(:price).dependent(:destroy)
    should belong_to :room_temperature
    should have_and_belong_to_many :styles
    
    # Validations
    should validate_presence_of :event_type
  }
  
  it 'should create an associated price object when initialized' do
    Course.new.price.should be_kind_of CoursePrice
    Course.new.price.should be_new_record
  end
  
  it 'should create an associated occurrence after being created' do
    course = Course.new # not save
    course.first_occurrence.should be_nil
    course = new_course # saved
    course.first_occurrence.should be_kind_of CourseOccurrence
  end
  
  # todo:1: make sure recurring course occurrences are properly saved
  context 'on create, when event_type is :recurring' do
    it 'creates one associated occurrence' do
      course = new_course(:event_type => :recurring, :occurrences => [
        {:week_day => 1, :time_span => '10am to 11am'}
      ])

      course.event_type.should == :recurring
      course.occurrences.length.should == 1
    end
    
    it 'uses the associated occurrence to store its week day and times' do
      course = new_course(:event_type => :recurring, :occurrences => [
        {:week_day => 1, :time_span => '10am to 11am'}
      ])

      course.first_occurrence.week_day.should == 1
      course.first_occurrence.start_time.hour.should == 10
      course.first_occurrence.end_time.hour.should == 11
    end
  end
  
  describe '#recurring?' do
    it 'returns true if event_type == :recurring' do
      new_course(:event_type => :recurring).should be_recurring
    end
    
    it 'returns false if event_type != :recurring' do
      new_course(:event_type => :single).should_not be_recurring
    end
  end
  
  describe '#single_date?' do
    it 'returns true if event_type == :single' do
      new_course(:event_type => :single).should be_single_date
    end
    
    it 'returns false if event_type != :recurring' do
      new_course(:event_type => :recurring).should_not be_single_date
    end    
  end

  describe '#multiple_date?' do
    it 'returns true if event_type == :multiple' do
      new_course(:event_type => :multiple).should be_multiple_date
    end
    
    it 'returns false if event_type != :multiple' do
      new_course(:event_type => :recurring).should_not be_multiple_date
    end    
  end
    
  # Chronic time parsing
  describe '#time_span' do
    it 'acts as a virtual setter for start_time and end_time' do
      course = new_course(:time_span => '11am to 1pm')
      course.save
      course.start_time.should == 11.hours
      course.end_time.should == 13.hours
    end
  end
  
  # We should be able to use a course-specific temperature,
  # or just pull the default value from the associated Room.
  describe '#room_temperature_id' do
    it 'returns the temperature of the associated room by default' do
      course = courses(:hatha)
      room   = course.room
      
      course.room_temperature_id.should == room.temperatures.first.id
    end
    
    it 'returns the course-specific room temperature where set' do
      course = courses(:hatha)
      temp   = RoomTemperature['Hot']
      
      course.update_attribute :room_temperature_id, temp.id
      course.reload.room_temperature_id.should == temp.id
    end
    
    it 'returns nil if neither value is present' do
      course = new_course # no associated room
      course.room_temperature_id.should == nil
    end
  end
  
  # As for room_temperature, so with maximum_capacity
  describe '#maximum_capacity' do
    it 'returns the capacity of the associated room by default' do
      course = courses(:hatha)
      room   = course.room
      
      course.maximum_capacity.should == room.capacity
    end
    
    it 'returns the course-specific capacity where set' do
      course = courses(:hatha)
      course.update_attribute :maximum_capacity, 100 # big course!
      course.maximum_capacity.should == 100      
    end
    
    it 'returns nil if neither value is present' do
      course = new_course # no associated room
      course.maximum_capacity.should == nil
    end    
  end
end