require 'spec_helper'

describe 'routing to AssignmentsController' do
  it 'routes GET /providers/1/studios/1/courses/1/course_occurrences/1/assignments/new do assignments#new' do
    {:get => 'providers/1/studios/2/courses/3/course_occurrences/4/assignments/new'}.should route_to(
      :controller   => 'assignments',
      :action       => 'new',
      :provider_id  => '1',
      :studio_id    => '2',
      :course_id    => '3',
      :course_occurrence_id => '4'
    )
  end
  
  it 'routes POST /providers/1/studios/2/courses/3/course_occurrences/4/assignments to assignments#create' do
    {:post => '/providers/1/studios/2/courses/3/course_occurrences/4/assignments'}.should route_to(
      :controller   => 'assignments',
      :action       => 'create',
      :provider_id  => '1',
      :studio_id    => '2',
      :course_id    => '3',
      :course_occurrence_id => '4'
    )
  end

  it 'routes PUT /providers/1/studios/2/courses/3/course_occurrences/4/assignments/5 to assignments#update' do
    {:put => 'providers/1/studios/2/courses/3/course_occurrences/4/assignments/5'}.should route_to(
      :controller   => 'assignments',
      :action       => 'update',
      :id           => '5',
      :provider_id  => '1',
      :studio_id    => '2',
      :course_id    => '3',
      :course_occurrence_id => '4'
    )
  end
  
  it 'routes DELETE /providers/1/studios/2/courses/3/course_occurrences/4/assignments/5 to assignments#destroy' do
    {:delete => '/providers/1/studios/2/courses/3/course_occurrences/4/assignments/5'}.should route_to(
      :controller   => 'assignments',
      :action       => 'destroy',
      :id           => '5',
      :provider_id  => '1',
      :studio_id    => '2',
      :course_id    => '3',
      :course_occurrence_id => '4'      
    )  
  end
end