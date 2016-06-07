require 'spec_helper'

describe Assignment do
  fixtures :all
  
  it {
    # Associations
    should belong_to :course
    should belong_to :course_occurrence
    should belong_to :staff_member
    should belong_to :role
  }
  
  it 'sets a default role before save' do
    a = Assignment.new
    a.role.should be_nil
    a.save
    a.role.should == AssignmentRole.find_by_name('Instructor')
  end
  
  it 'does not override custom roles' do
    role = assignment_roles(:assistant)
    a = Assignment.new(:role_id => role.id)
    a.save
    a.role.should == role
  end
end
