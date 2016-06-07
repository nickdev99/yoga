require 'spec_helper'

describe CoursePrice do
  it {
    should belong_to :course
  }
end
