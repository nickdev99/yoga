require 'spec_helper'

describe Room do
  it {
    should have_many :courses
    should belong_to :studio
    should belong_to :default_temperature
    should have_and_belong_to_many :temperatures
    should validate_presence_of :name
    should validate_presence_of :capacity
    should validate_numericality_of :capacity
  }
end
