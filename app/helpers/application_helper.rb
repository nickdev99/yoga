module ApplicationHelper  
  # Returns an array of [text, value] pairs for select tag options.
  #
  # Text and value are taken from a model whose name is given
  # in the +subject+ param. Text and value are used as follows
  # when Rails builds option tags:
  #
  #   '<option value="value">text</option>'
  #
  # Value defaults to :id (returning the database id), but
  # is overridable:
  #
  #   select_tag_options_for(:post, :title, :slug)
  #   # could give...
  #   [['First Post', 'first-post'], ['Second Post', 'second-post']]
  #
  # == Using a pre-built collection
  #
  # Given +Blog.has_manye :contributors+:
  #
  #   select_tag_options_for(@blog.contributors, :name)
  #   # could give...
  #   [['John Smith', 1], ['Jane Doe', 2]]
  #
  # @param [Symbol, Array] subject The name of the model or a collection of model objects
  # @param [Symbol] text The attibute to use as the option tag text
  # @param [Symbol] value The attribute to use as the option tag value
  #
  # @see ActionView::Helpers::FormOptionsHelper#select
  def select_tag_options_for(subject, text_attribute, value_attribute = :id)
    unless subject.kind_of? Array
      subject = subject.to_s.classify.constantize.all
    end

    subject.map do |m|
      [m.send(text_attribute), m.send(value_attribute)]
    end
  end
  
  # Just a convenience method which returns the collection of all AssignmentRoles
  def assignment_roles
    AssignmentRole.all
  end
  
  # Returns the ID value for a room temperature
  # with a given name. Will raise an error if
  # no room temperature with the given name exsits.
  #
  # @param [String] name The room temperature name
  def room_temperature_id(name)
    RoomTemperature[name].id
  end
  
  # Converts a Date object into a formatted string.
  # Only includes the year if the date is outside the
  # current year.
  #
  # @param [CourseOccurrence] the occurrence whose
  #   date we want to format
  def human_occurrence_date(occurrence)
    if date = occurrence.date
      if date.year == Date.today.year
        date.strftime '%B %d'
      else
        date.strftime '%B %d, %Y'
      end
    end
  end
  
  # Returns a text field with custom attributes
  # based on a specific course occurrence.
  #
  # The field is used by the user for entering
  # course time spans, eg "9am to 10am".
  #
  # @param [CourseOccurrence] the occurrence to customise for
  def time_span_field_for(occurrence)
    text_field_tag "occurrence_#{occurrence.id}[time_span]", nil,
 									 :id 						 			=> "occurrence_#{occurrence.id}_time_span",
									 :class 				 			=> 'occurrence_time_span',
 									 'data-ajax-url' 		 	=> course_length_path,
									 'data-update-target' => "#occurrence_#{occurrence.id}_time_span_length"    
  end
  
  # Returns an empty "<span></span>" tag, with custom
  # attributes based on a specific course occurrence. 
  #
  # @param [CourseOccurrence] the occurrence to customise for  
  def occurrence_length_tag(occurrence)
    content_tag :span, nil, :id => "occurrence_#{occurrence.id}_time_span_length"    
  end
  
  def filter_link_to(title, path, condition)
    content_tag(:li, link_to(title, path, :class => ('current' if condition)))
  end
  
  # Return defoult title if title not defined
  def render_title
    @title ? @title : "I Live Yoga - #{@city.capitalize} :: All Studios. All Classes."
  end
  
  def worshop_type(event)
    "Multiple days" if event.multiple_date?
  end
end
