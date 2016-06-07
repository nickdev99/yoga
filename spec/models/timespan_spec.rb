require 'spec_helper'

describe Timespan do
  it 'initializes with a span string' do
    new_timespan.should be_kind_of Timespan
  end
  
  describe '#span' do
    it 'returns the timespan string' do
      new_timespan('8am to 9:30am').span.should == '8am to 9:30am'
    end
  end
  
  describe '#length' do
    it 'returns a float value for the timespan length' do
      new_timespan('10am to 11am').length.should == 1.hour
      new_timespan('7am to 9am').length.should == 2.hours
      new_timespan('11am to 12:30pm').length.should == 1.5.hours
    end
  end
  
  describe '#length_in_words' do
    it 'returns a string value representing the timespan length' do
      new_timespan('8am to 9am').length_in_words.should == '1 hour'
      new_timespan('8am to 9:30am').length_in_words.should == '1 hour 30 minutes'
      new_timespan('8am to 9:25am').length_in_words.should == '1 hour 25 minutes'      
      new_timespan('7am to 9:45am').length_in_words.should == '2 hours 45 minutes'            
    end
  end
end
