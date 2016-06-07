require 'spec_helper'

describe 'routing to SchedulesController' do
  it 'routes GET /providers/1/studios/2/schedules to schedules#index' do
    {:get => '/providers/1/studios/2/schedules'}.should route_to(
      :controller   => 'schedules',
      :action       => 'index',
      :provider_id  => '1',
      :studio_id    => '2'
    )
  end
  
  it 'routes GET /providers/1/studios/2/schedules/2011/03/01 to schedules#show' do
    {:get => '/providers/1/studios/2/schedules/2011/03/01'}.should route_to(
      :controller   => 'schedules',
      :action       => 'show',
      :year         => '2011',
      :month        => '03',
      :day          => '01',
      :provider_id  => '1',
      :studio_id    => '2'
    )
  end
end