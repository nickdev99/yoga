require 'spec_helper'

describe ExperienceLevel do
  it {
    should validate_presence_of :name
    should validate_uniqueness_of :name
  }
end
