require 'spec_helper'

describe Provider do
  it {
    should have_many :studios
    should have_and_belong_to_many :staff_members
    should validate_presence_of :name
    should validate_uniqueness_of :name
  }
end
