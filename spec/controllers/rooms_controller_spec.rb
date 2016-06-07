require 'spec_helper'

describe RoomsController do
  fixtures :all
  
  before :each do
    @provider = providers(:first)
    @studio   = @provider.studios.first
  end
  
  describe 'GET :new' do
    it 'initializes a new room and renders rooms/new' do
      get :new, :provider_id => @provider.id, :studio_id => @studio.id

      response.should be_success
      assigns(:room).should be_kind_of Room
      assigns(:room).should be_new_record
      response.should render_template 'rooms/new'
    end
  end
  
  describe 'GET show' do
    context 'via XHR' do
      it 'renders JSON for an existing room' do
        room = rooms(:first)
        
        xhr :get, :show, :id => room.id,
            :provider_id => @provider.id,
            :studio_id   => @studio.id
        
        response.should render_json room.to_json(:include => [:studio, :temperatures])
      end
    end
  end
  
  describe 'POST :create' do
    context 'with valid params' do
      it 'creates a new room and redirects to studios#show' do
        warm = room_temperatures(:warm)
        hot  = room_temperatures(:hot)
        
        post :create, :provider_id => @provider.id, :studio_id => @studio.id,
          :room => {
            :name             => 'New Room', 
            :temperature_ids  => [warm.id, hot.id], 
            :capacity         => 10,
            :default_temperature_id => warm.id            
          }
        
        @studio.rooms.last.name.should == 'New Room'
        @studio.rooms.last.temperatures.should == [warm, hot]
        @studio.rooms.last.default_temperature.should == warm
        
        response.should redirect_to provider_studio_path(@provider, @studio)        
      end
    end
  end
end
