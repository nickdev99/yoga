require 'spec_helper'

describe PracticeLevel do
  it {
    should validate_presence_of :name
    should validate_uniqueness_of :name
  }
end
