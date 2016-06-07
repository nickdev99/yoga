module CourseFormHelper
  # Build an array of partial paths based on the contents
  # of the app/views/courses/new directory.
  #
  # Array contents should be valid partial names for use
  # in "render :partial => name", eg:
  #
  #   # file path
  #   app/views/courses/new/_a_course_type.html.erb
  #   # partial name
  #   courses/new/a_course_type
  #
  # The order of the files in courses/new should be the same
  # as the order in which sections will be shown on the new
  # course form.
  #
  # @see render_form_section
  COURSE_FORM_PARTIALS = Dir[Rails.root.join('app/views/courses/new/*.html.erb')].map do |path|
    file_name  = path.gsub(/\/_/, '/')
    view_name = File.basename(file_name, '.html.erb')

    File.join('courses/new', view_name)
  end.freeze
  
  # Renders a section of the new course form as a partial,
  # with the locals provided.
  def render_form_section(step_number)
    render :partial => form_section_partial(step_number)
  end
  
  def form_section_partial(step_number)
    COURSE_FORM_PARTIALS[step_number - 1]    
  end
end