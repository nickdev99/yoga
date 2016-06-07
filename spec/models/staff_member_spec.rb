require 'spec_helper'

describe StaffMember do
  fixtures :all
  
  it {
    # Associations
    should have_and_belong_to_many :providers
    should have_many :assignments
    should have_many(:courses).through :assignments
    
    # Validations
    should validate_presence_of :first_name    
    should validate_presence_of :last_name
  }
  
  describe '#name' do
    it 'returns the conjunction of first_name and last_name' do
      john = staff_members(:john)
      john.name.should == [john.first_name, john.last_name].join(' ')
    end
  end
end
