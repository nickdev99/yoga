require 'spec_helper'

describe 'routing to RoomsController' do
  it 'routes /providers/:id/studios/:id/rooms/new to rooms#new' do
    {:get => 'providers/1/studios/2/rooms/new'}.should route_to(
      :controller   => 'rooms',
      :action       => 'new',
      :provider_id  => '1',
      :studio_id    => '2'
    )
  end
  
  it 'routes /providers/1/studios/2/rooms/3 to rooms#show' do
    {:get => 'providers/1/studios/2/rooms/3'}.should route_to(
      :controller   => 'rooms',
      :action       => 'show',
      :id           => '3',
      :provider_id  => '1',
      :studio_id    => '2'
    )
  end
end