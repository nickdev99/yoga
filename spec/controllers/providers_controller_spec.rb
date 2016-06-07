require 'spec_helper'

describe ProvidersController do
  describe 'GET :new' do
    it 'initializes a new provider and renders providers/new' do
      get :new
      response.status.should == 200
      assigns(:provider).should be_kind_of Provider
      assigns(:provider).should be_new_record
      response.should render_template 'providers/new'
    end
  end
  
  describe 'POST create' do
    context 'with valid params' do
      it 'creates a new provider and redirects to courses/new' do
        post :create, :provider => {:name => 'Yoga, Inc'}
        
        provider = Provider.last
        provider.name.should == 'Yoga, Inc'
        response.should redirect_to new_provider_studio_path(provider)
      end
    end
  end
end
