require 'spec_helper'

describe 'routing to CourseOccurrencesController' do
  it 'routes GET /providers/1/studios/2/courses/3/course_occurences/new to course_occurrences#new' do
    {:get => 'providers/1/studios/2/courses/3/course_occurrences/new'}.should route_to(
      :controller   => 'course_occurrences',
      :action       => 'new',
      :provider_id  => '1',
      :studio_id    => '2',
      :course_id    => '3'
    )
  end
  
  it 'routes POST /providers/1/studios/2/courses/3/course_occurrences to course_occurrences#create' do
    {:post => '/providers/1/studios/2/courses/3/course_occurrences'}.should route_to(
      :controller => 'course_occurrences',
      :action     => 'create',
      :provider_id  => '1',
      :studio_id    => '2',
      :course_id    => '3'      
    )
  end
end