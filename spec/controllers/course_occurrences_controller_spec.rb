require 'spec_helper'

describe CourseOccurrencesController do
  fixtures :all
  
  before :each do
    @provider   = providers(:first)
    @studio     = @provider.studios.first
    @course     = @studio.courses.first
    @occurrence = @course.first_occurrence
  end
  
  describe 'POST create' do
    context 'via XHR with valid params for a multiple date course' do
      it 'creates a new occurrences for a course, and renders course_occurrences/index' do
        xhr :post, :create,
            :provider_id  => @provider.id,
            :studio_id    => @studio.id,
            :course_id    => @course.id,
            :day          => '01',
            :month        => '04',
            :year         => '2011',
            :event_type   => 'multiple'
        
        @course.occurrences.last.date.should == Date.new(2011, 4, 1)
        @course.occurrences.length.should == 2        
        
        response.should render_template 'course_occurrences/index'
        response.should_not render_template 'layouts/application'
      end
    end
    
    context 'via XHR with valid params for a single date course' do
      it 'changes the only occurrence for a course, and renders course_occurrences/show' do
        xhr :post, :create,
            :provider_id  => @provider.id,
            :studio_id    => @studio.id,
            :course_id    => @course.id,
            :day          => '01',
            :month        => '04',
            :year         => '2012',
            :event_type   => 'single'
            
        @course.occurrences.last.date.should == Date.new(2012, 4, 1)
        @course.occurrences.length.should == 1    
        
        response.should render_template 'course_occurrences/show'
        response.should_not render_template 'layouts/application'                    
      end
    end
  end
  
  describe 'GET new' do
    it 'renders course_occurrences/new for a given course' do
      xhr :get, :new,
          :provider_id  => @provider.id,
          :studio_id    => @studio.id,
          :course_id    => @course.id
          
      response.should render_template 'course_occurrences/new'
      response.should_not render_template 'layouts/application'
    end
  end
  
  describe 'DELETE destroy' do
    it 'destroys an occurrences and renders course_occurrences/index' do
      xhr :delete, :destroy, :id => @occurrence.id,
          :provider_id  => @provider.id,
          :studio_id    => @studio.id,
          :course_id    => @course.id

      @course.occurrences.should_not include(@occurrence)
      
      response.should render_template 'course_occurrences/index'
      response.should_not render_template 'layouts/application'
    end
  end
end
