require 'spec_helper'

describe RoomTemperature do
  it {
    should have_many :rooms
    should validate_presence_of :name
  }
  
  describe '.[name]' do
    it 'acts as an alias for .find_by_name(name)' do
      RoomTemperature.all.each do |temp|
        RoomTemperature[temp.name].should_not be_nil
        RoomTemperature[temp.name].should == temp
      end
    end
  end
end
