require 'spec_helper'

describe 'routing to CoursesController' do
  it 'routes /providers/1/studios/2/courses/new to courses#new' do
    {:get => 'providers/1/studios/2/courses/new'}.should route_to(
      :controller   => 'courses',
      :action       => 'new',
      :provider_id  => '1',
      :studio_id    => '2'
    )
  end
  
  it 'routes /providers/1/studios/2/courses to courses#index' do
    {:get => 'providers/1/studios/2/courses'}.should route_to(
      :controller => 'courses',
      :action     => 'index',
      :provider_id  => '1',
      :studio_id    => '2'      
    )
  end
  
  it 'route GET /courses/length?timespan=10am%20to%2011am to courses#length' do
    {:get => 'courses/length'}.should route_to(
      :controller => 'courses',
      :action     => 'length'
    )
  end
  
  it 'routes POST /providers/1/studios/2/courses to courses#create' do
    {:post => '/providers/1/studios/2/courses'}.should route_to(
      :controller   => 'courses',
      :action       => 'create',
      :provider_id  => '1',
      :studio_id    => '2'
    )
  end
end