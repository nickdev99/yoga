require 'spec_helper'

describe 'routing to StaffMembersController' do
  it 'routes /providers/1/staff_members/new to staff_members#new' do
    {:get => 'providers/1/staff_members/new'}.should route_to(
      :controller   => 'staff_members',
      :action       => 'new',
      :provider_id  => '1'
    )
  end
  
  it 'routes POST /providers/1/staff_members to staff_members#create' do
    {:post => 'providers/1/staff_members'}.should route_to(
      :controller   => 'staff_members',
      :action       => 'create',
      :provider_id  => '1'
    )
  end
  
  it 'routes PUT /providers/1/staff_members/update_all to staff_members#update_collection' do
    {:put => 'providers/1/staff_members/update_all'}.should route_to(
      :controller   => 'staff_members',
      :action       => 'update_all',
      :provider_id  => '1'
    )
  end
  
  it 'routes /providers/1/staff_members/2 to staff_members#show' do
    {:get => 'providers/1/staff_members/2'}.should route_to(
      :controller   => 'staff_members',
      :action       => 'show',
      :provider_id  => '1',
      :id           => '2'
    )
  end
end