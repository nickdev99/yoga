require 'spec_helper'

describe 'routing to ProvidersController' do
  it 'routes /providers/new to providers#new' do
    {:get => 'providers/new'}.should route_to(
      :controller => 'providers',
      :action     => 'new'
    )
  end
  
  it 'routes POST /providers to providers#create' do
    {:post => 'providers'}.should route_to(
      :controller => 'providers',
      :action     => 'create'
    )
  end
end