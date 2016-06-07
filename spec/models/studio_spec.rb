require 'spec_helper'

describe Studio do
  it {
    should belong_to :provider
    should have_many :courses
    should have_many :rooms
  }
end
