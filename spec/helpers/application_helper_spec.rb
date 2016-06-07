require 'spec_helper'

describe ApplicationHelper do
  fixtures :all
  
  describe '#select_tag_options_for' do
    it 'returns an array of text/value options for a select tag' do
      expected = ExperienceLevel.all.map { |l| [l.name, l.id] }
      actual   = helper.select_tag_options_for(:experience_level, :name)
      
      actual.should == expected
    end
    
    context 'when given an array' do
      it 'uses the array as the source of key/value pairs' do
        rooms    = studios(:first).rooms
        expected = rooms.map { |r| [r.name, r.id] }
        actual   = helper.select_tag_options_for(rooms, :name)
        
        actual.should == expected
      end
    end
  end
  
  describe '#assignment_roles' do
    it 'returns an array of assignment roles' do
      helper.assignment_roles.should == AssignmentRole.all
    end
  end
  
  describe '#room_temperature_id' do
    it 'returns the ID of a RoomTemperature, found by name' do
      RoomTemperature.all.each do |temp|
        helper.room_temperature_id(temp.name).should == temp.id
      end
    end
  end
  
  describe '#human_occurrence_date' do
    context 'with a date in the current year' do
      it 'returns a string with day and month' do
        occurrence = CourseOccurrence.new(:date => Date.today)
        expected   = Date.today.strftime('%B %d')

        helper.human_occurrence_date(occurrence).should == expected
      end
    end
    
    context 'with a date not in the current year' do
      it 'returns a string with data, month, and year' do
        occurrence = CourseOccurrence.new(:date => 1.year.from_now)
        expected   = 1.year.from_now.strftime('%B %d, %Y')

        helper.human_occurrence_date(occurrence).should == expected        
      end
    end
  end
  
  describe '#time_span_field_tag_for(occurrence)' do
    it 'returns a text field tag with custom attributes' do
      occurrence = CourseOccurrence.create!(:date => 1.year.from_now)
      expected   = text_field_tag "occurrence_#{occurrence.id}[time_span]", nil,
               									  :id 						 		 => "occurrence_#{occurrence.id}_time_span",
              									  :class 				 			 => 'occurrence_time_span',
               									  'data-ajax-url' 		 => course_length_path,
              									  'data-update-target' => "#occurrence_#{occurrence.id}_time_span_length"
			
			helper.time_span_field_for(occurrence).should == expected
    end
  end
  
  describe '#occurrence_length_tag' do
    it 'returns an empty span tag with a custom id' do
      occurrence = CourseOccurrence.create!(:date => 1.year.from_now)
      expected   = content_tag :span, nil, :id => "occurrence_#{occurrence.id}_time_span_length"
      
      helper.occurrence_length_tag(occurrence).should == expected
    end
  end
end
