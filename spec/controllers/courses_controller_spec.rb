require 'spec_helper'

describe CoursesController do
  fixtures :all
  
  before :each do
    @provider = providers(:first)
    @studio   = studios(:first)
  end
  
  describe 'GET :new' do
    it 'instantiates a new Course object and renders courses/new' do
      get :new, :provider_id => @provider.id, :studio_id => @studio.id
      
      response.status.should == 200
      assigns(:course).should be_kind_of Course
      assigns(:course).should be_new_record
      assigns(:course).studio.should == @studio
      response.should render_template 'courses/new'
    end
  end
  
  describe 'POST :create' do
    context 'via xhr with valid params' do
      it 'creates a new course for a studio and renders step two' do
        xhr :post, :create, :course => {:event_type => :recurring},
            :next_step       => 2,
            :provider_id     => @provider.id,
            :studio_id       => @studio.id

        assigns(:course).should be_kind_of Course
        assigns(:course).should be_persisted
        assigns(:course).event_type.should == :recurring
        
        response.should render_template 'courses/new/_b_course_dates'
        response.should_not render_template 'layouts/application'
      end      
    end    
  end
  
  describe 'POST :update' do
    context 'via xhr with valid params' do
      it 'updates a course and renders the next step' do
        course = @studio.courses.first
        
        xhr :post, :update, :course => {:week_day => 6, :time_span => '10am to 11am'},
            :next_step    => 3,
            :provider_id  => @provider.id,
            :studio_id    => @studio.id,
            :id           => course.id
        
        assigns(:course).should == course
        assigns(:course).week_day.should == 6
        assigns(:course).time_span.should == '10am to 11am'
        assigns(:course).errors.should be_empty
        
        response.should render_template 'courses/new/_c_course_details'
        response.should_not render_template 'layouts/application'
      end
    end
  end
  
  describe 'GET :index' do
    it 'loads all courses and renders courses/index' do
      get :index, :provider_id => @provider.id, :studio_id => @studio.id
      
      response.status.should == 200
      assigns(:courses).should == Course.all
      response.should render_template 'courses/index'
    end
  end
  
  describe 'GET length' do
    context 'via XHR with valid params' do
      it 'returns a float length based on a timespan' do
        timespan = new_timespan
        
        xhr :get, :length, :span => timespan.span
        
        response.should be_success
        response.body.should == timespan.length_in_words
      end
    end
  end
end
