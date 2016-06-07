require 'spec_helper'

describe CourseOccurrence do
  it {
    should belong_to :course    
    should have_many :assignments
    should have_many(:staff_members).through(:assignments)
  }
  
  it 'creates a Timespan from a string when saved' do
    o = new_course_occurrence(:time_span => '11am to noon')
    
    o.save
    
    o.time_span.should be_kind_of Timespan
    o.time_span.start_time.hour.should == 11
    o.time_span.end_time.hour.should == 12
  end
end

def new_course_occurrence(options = {})
  CourseOccurrence.new(options)
end
