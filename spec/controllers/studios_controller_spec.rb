require 'spec_helper'

describe StudiosController do
  fixtures :all

  before :each do
    @provider = providers(:first)
  end
  
  describe 'GET :index' do
    it 'loads all studios for a specific provider and renders studios/index' do
      get :index, :provider_id => @provider.id
      
      response.should be_success
      assigns(:studios).should == @provider.studios
      response.should render_template 'studios/index'
    end
  end
  
  describe 'GET :new' do
    it 'initializes a new studio and renders studios/new' do
      get :new, :provider_id => @provider.id

      response.should be_success
      assigns(:studio).should be_kind_of Studio
      assigns(:studio).should be_new_record
      response.should render_template 'studios/new'
    end
  end
  
  describe 'GET :show' do
    it 'renders studios/show for an existing studio' do
      studio = @provider.studios.first
      
      get :show, :provider_id => @provider.id, :id => studio.id
      
      response.should be_success
      response.should render_template 'studios/show'
    end
  end
  
  describe 'POST :create' do
    context 'with valid params' do
      it 'creates a new studio and redirects to studios#index' do
        post :create, :provider_id => @provider.id,
          :studio => {:name => 'First Studio', :minimum_course_capacity => 10}
        
        @provider.studios.last.name.should == 'First Studio'
        @provider.studios.last.minimum_course_capacity.should == 10
        response.should redirect_to provider_studios_path(@provider)
      end
    end
  end
end
