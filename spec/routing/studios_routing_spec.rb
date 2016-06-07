require 'spec_helper'

describe 'routing to StudiosController' do
  it 'routes /providers/:id/studios to studios#index' do
    {:get => 'providers/1/studios'}.should route_to(
      :controller  => 'studios',
      :action      => 'index',
      :provider_id => '1'
    )
  end
  
  it 'routes /providers/:id/studios/:id to studios#show' do
    {:get => 'providers/1/studios/2'}.should route_to(
      :controller   => 'studios',
      :action       =>'show',
      :provider_id  => '1',
      :id           => '2'
    )
  end
  
  it 'routes /providers/:id/studios/new to studios#new' do
    {:get => 'providers/1/studios/new'}.should route_to(
      :controller  => 'studios',
      :action      => 'new',
      :provider_id => '1'
    )
  end
end