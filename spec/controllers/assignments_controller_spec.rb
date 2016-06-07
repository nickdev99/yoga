require 'spec_helper'

describe AssignmentsController do
  fixtures :all
  
  before :each do
    @provider   = providers(:first)
    @studio     = @provider.studios.first
    @course     = @studio.courses.first
    @occurrence = @course.first_occurrence
  end
  
  describe 'GET new' do
    context 'via XHR' do
      it 'initializes a new assignment and renders/assignments new without layout' do
        xhr :get, :new, 
          :provider_id => @provider.id, 
          :studio_id   => @studio.id,
          :course_id   => @course.id,
          :course_occurrence_id => @occurrence.id
          
        assigns(:assignment).should be_kind_of Assignment
        assigns(:assignment).should be_new_record

        response.should render_template 'assignments/new'
        response.should_not render_template 'layouts/application'
      end
    end
  end
  
  describe 'POST :create' do
    context 'via XHR with valid params for an existing staff member' do
      it 'assigns the staff member to a course occurrence and renders assignments/index' do
        john       = staff_members(:john)        

        @course.staff_members.should_not include(john)
        @occurrence.staff_members.should_not include(john)
        
        xhr :post, :create, 
          :provider_id  => @provider.id,
          :studio_id    => @studio.id,
          :course_id    => @course.id,
          :course_occurrence_id => @occurrence.id,
          :assignment   => {
            :staff_member_id => john.id,
          }
        
        assigns(:staff_member).should == john
        assigns(:course).should == @course
        
        @occurrence.reload.staff_members.should include(john)
        @course.staff_members.should include(john)        
        
        # check rendering
        response.should render_template 'assignments/index'
        response.should_not render_template 'layouts/application'
      end
    end
    
    context 'via XHR with valid params for a non-existing staff member' do
      it 'creates a new staff member and assigns them to a course occurrence' do
        StaffMember.find_by_first_name_and_last_name('Joe', 'Blogs').should be_nil

        xhr :post, :create,
          :provider_id  => @provider.id,
          :studio_id    => @studio.id,
          :course_id    => @course.id,
          :course_occurrence_id => @occurrence.id,
          :assignment   => {:staff_member => {
            :first_name => 'Joe',
            :last_name  => 'Blogs'
          }}

        assigns(:staff_member).should be_kind_of StaffMember
        assigns(:staff_member).should be_persisted
        assigns(:course).should == @course

        @course.staff_members.should include(assigns(:staff_member))
        @occurrence.reload.staff_members.should include(assigns(:staff_member))
      end
    end
    
    describe 'PUT update' do
      context 'via XHR with valid params' do
        it 'updates an assignment and renders assingmnets/index' do
          assignment = @course.assignments.first
          role       = assignment_roles(:assistant)
          
          assignment.role.should_not == role
          
          xhr :put, :update, :id => assignment.id, 
              :assignment  => {:role_id => role.id},
              :provider_id => @provider.id,
              :studio_id   => @studio.id,
              :course_id   => @course.id,
              :course_occurrence_id => @occurrence.id
              
          Assignment.find(assignment.id).role.should == role
          
          response.should render_template 'assignments/index'
          response.should_not render_template 'layouts/application'
        end
      end
    end
    
    describe 'DELETE destroy' do
      context 'via XHR with valid params' do
        it 'deletes an assignment and renders assingments/index' do   
          assignment = @occurrence.assignments.first
                 
          xhr :delete, :destroy, :id => assignment.id,
              :provider_id => @provider.id,
              :studio_id   => @studio.id,
              :course_id   => @course.id,
              :course_occurrence_id => @occurrence.id
          
          @course.assignments.should_not include(assignment)
          @occurrence.assignments.should_not include(assignment)
          
          response.should render_template 'assignments/index'
          response.should_not render_template 'layouts/application'          
        end
      end
    end
  end
end
