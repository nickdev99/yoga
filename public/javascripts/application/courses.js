function add_instructor(id, name) {
    var placeHolder = $('#assigned_instructors');
    items = placeHolder.find('p').length;
    var instructor =  $('</p>').append(name + '<input id="course_assignments_staff_member_id_'+ id +'" name="course[assignments_attributes]'+items+'[staff_member_id]" value="'+id+'" type="hidden">')
    if($('#course_assignments_staff_member_id_'+ id).length < 1){
        placeHolder.append(instructor);
    }
}

// Time span length
function timeSpanLength (value, target, url) {
    setTimeout(function(){
        if (value != '') {
            $.ajax(url, {
                type: 'GET',
                data: {
                    span: value
                },
                success: function(content, status, xhr) {
                    $(target).html(content);
                },
                error: function(){
                    target.html('');
                }
            });
        } else {
            $(target).html('');
        }
    }, 5);
}

function odserv_events(){
    // Courses form js classes

    var courses = {
        form: 					$('#course_form'),
        sections: 			$('#course_form').find('fieldset'),
        course_type: 		null,
        stepsList: 			$('#steps.coursesSteps ul'),
        editCourse: 		false,
        // course sections
        event_type: 				$('#event_type'),
        course_dates: 			$('#course_dates'),
        course_details: 		$('#course_details'),
        course_instructors: $('#course_instructors'),
        course_cost: 				$('#course_cost'),
        course_done: 				$('#course_done'),
        // Details for header
        course_header: {
            start_time: 	$('#timing string'),
            time_span: 		$('#timing span'),
            name: 				$('#details strong'),
            room_details: $('#details span'), // ex: ROOM_NAME (ROMM_TEMPERATURE_NAME)
        }
    }

    function initialize () {
        courses.sections.hide();
        courses.sections.first().show();

        if (!editCourse) {
            courses.stepsList.children('li').hide();
        }
        else {
            courses.course_type = course_type;
            goToStep('course_dates');
        }

        $('#week_days, #room_temperature, #experience_level, #practice_level, #rooms').buttonset();
        $('[data-step]').click(function(event){
            event.preventDefault();
            goToStep($(this).attr('data-step'));
        })

        $('.reveal').click(function(event){
            event.preventDefault();
            var inputID = $(this).attr('href');
            $(inputID).toggle();
        })
        course_styles_list = [];
        load_styles();
    }

    ////////////////////
    // Core functions //
    ////////////////////

    // Go to next step
    function goToStep (step) {
        courses.sections.hide();
        courses.form.find('#'+step).show();

        $('[data-step="'+step+'"]').parents('li').show();
        $('.steps li a').attr("class", "");
        $('.steps li [data-step="'+step+'"]').attr("class", "current");

        if (step === 'course_dates') {
            courses.course_dates.children('div').hide();
            courses.course_dates.children('div').find('input').attr('disabled','disabled');
            courses.course_dates.find('#'+courses.course_type).find('input').removeAttr('disabled');
            courses.course_dates.find('#'+courses.course_type).show('slow',function(){
                initializeDatePicker();
            });
        }
    }

 

    function updateHeader () {
        courses.course_header.start_time.html('');
        courses.course_header.time_span.html('');
        courses.course_header.name.html($('#course_name').val())
        courses.course_header.room_details.html($('#course_room_id option[selected]').html()+' ('+$('#room_temperature .ui-state-active span').html()+')')
    }

    /////////////////////
    // Sections events //
    /////////////////////

    // Event type
    courses.event_type.find('li').live('click', function(event) {
        if (event.target.type !== 'radio') {
            $(':radio', this).trigger('click');
            $(':radio', this).trigger('change');
        }
        courses.course_type = $(':radio', this).val();
        goToStep('course_dates');
    });

    // Event dates

    courses.course_dates.find('.time_span').live('keyup', function() {
        var url  	 = '/courses/length',
        target = $(this).parents('p').find('.course_length'),
        value	 = $(this).val();

        timeSpanLength (value, target, url);
    });


    function initializeDatePicker(){
        // single day
        if (courses.course_type === 'single') {
            $('#single-picker').datepicker({
                minDate: 0,
                dateFormat: 'dd-mm-yy',
                onSelect: function(dateText, datePicker) {
                    courses.course_dates
                    .find('#single')
                    .find('#occurrences_date')
                    .val(dateText);

                }
            }).datepicker('setDate', courses.course_dates.find('#single').find('#occurrences_date').val()).show();
        }
        // multiple days
        if (courses.course_type === 'multiple'){
            var listTarget = courses.course_dates.find('#multiple').find('#multiple_days_list');
            var datesList = [];
            $('#multiple-picker').datepicker({
                minDate: 0,
                dateFormat: 'dd-mm-yy',
                onSelect: function(dateText, datePicker) {
                    if (datesList.toString().search(dateText) > -1) return false;
                    datesList.push(dateText);
                    var newDay = $('<p/>')
                    .append($('<h3/>').html(dateText+' ').append($('<a/>').html('remove')))
                    .append($('<input/>').attr({
                        'name': 	'course[occurrences_attributes]['+datesList.length+'][time_span]',
                        'type': 	'text',
                        'class': 	'multiple_time_span'
                    }))
                    .append($('<input/>').attr({
                        'name': 	'course[occurrences_attributes]['+datesList.length+'][date]',
                        'type': 	'hidden',
                        'value': 	dateText
                    }))
                    .append($('<span/>').attr('class','course_length'));
                    newDay.find('.multiple_time_span').keyup(function() {
                        var url  	 = '/courses/length',
                        target = $(this).parents('p').find('.course_length'),
                        value	 = $(this).val();

                        timeSpanLength (value, target, url);
                    });
                    newDay.find('h3 a').click(function(){
                        $(this).parents('p').remove();
                    })

                    listTarget.append(newDay);
                }
            }).show();
        }
    }

    courses.course_dates.find('input[type=submit]').live('click',function(event){
        event.preventDefault();
        goToStep('course_details');
        updateHeader();
    });


    /*
		Course styles
	*/
    $('#course_styles ul input:checkbox').change(function(event){
        course_styles_list = [];
        load_styles();
    });

    function load_styles() {
        $('#course_styles ul input:checkbox:checked').each(function(){
            course_styles_list.push($(this).attr('data-name'));
        })
        $('#course_styles_ph span').html('');
        jQuery.each(course_styles_list, function(i,val){
            $('#course_styles_ph span').append(val+', ');
        })
    }

    /*
	Room
	--

	The first time a room is selected for a course, populate the
	room fields with data from the selected room.

	Relevant data is:
		- Room temperature
		- Maximum capacity
	*/
    $('#course_room_id').live('change', function() {
        var option   = $(this).find(':selected'),
        id		   = option.val(),
        url_base = $('#room_url_base').val(),
        url			 = url_base + '/' + id;

        $.ajax(url, {
            type: 'GET',
            dataType: 'json',
            success: function(json, status, xhr) {
                // Set default room temperature for course
                var radios = $('input[name="course[room_temperature_id]"]');

                radios.each(function() {
                    if ($(this).val() == json.room.default_temperature_id) {
                        $(this).attr('checked', 'checked');
                    };
                });

                // Hide room temperature options which don't apply to the room
                $('[name="course[room_temperature_id]"]').each(function() {
                    var id 		= $(this).val(),
                    temps = json.room.temperatures,
                    hide	= true;

                    for (var i=0; i < temps.length; i++) {
                        if (temps[i].id == id) {
                            hide = false;
                        };
                    };

                    if (hide) {
                        $(this).closest('li').hide();
                    } else {
                        $(this).closest('li').show();
                    }
                });

                // Set default minimum capacity
                var input = $('#course_minimum_capacity'),
                val	  = input.val();

                if (val == '') {
                    // Only proceed if minimum capacity isn't already set
                    input.val(json.room.studio.minimum_course_capacity);
                };

                // Set default maximum capacity
                var	input	=	$('#course_maximum_capacity'),
                val		= input.val();

                if (val == '') {
                    // Only proceed if maximum capacity isn't already set
                    input.val(json.room.capacity);
                };
            }
        });
    });

    /*
	Instructors
	--

	Functionality for the 'Add' link (for existing staff members).
	*/

    /*
	Show the new instructor form via AJAX when the 'New Person' link is clicked
	*/
    $('a#add_person').live('click', function(event) {
        event.preventDefault();
        $('#new_stuff_member_form').show();
    });

    $('#new_stuff_member_form').hide();

    $('#new_stuff_member_form input:button').click(function(){
        var url = $('#new_stuff_member_form').attr('data-url'),
        data = {
            staff_member: {
                first_name: $('#new_stuff_member_form .instructor_first_name').val(),
                last_name: 	$('#new_stuff_member_form .instructor_last_name').val()
            }
        };

        $.ajax(url, {
            type: 'POST',
            data: data,
            success: function(content, status, xhr) {
                $('#new_stuff_member_form input:text').val('');
                $('#new_stuff_member_form').hide();
                var new_member = '<option value='+content+'>'+data.staff_member.first_name+' '+data.staff_member.last_name+'</option>';
                console.log(new_member);
                $('#instructor_id').append(new_member);
            }
        })

    });

    /*
	Update assignment roles via AJAX when a new role is selected
	*/
    $('#course_assignments li input[type=radio]').live('change', function() {
        var name 	 = $(this).attr('name'),
        group	 = '[name="' + name + '"]',
        button = $(group).filter(':checked'),
        id		 = button.val(),
        url		 = button.attr('data-target-url'),
        data   = {
            assignment: {
                role_id: id
            }
        };

        $.ajax(url, {
            type: 'PUT',
            data: data,
            success: function(content, status, xhr) {
                $('#assigned_instructors').html(content);
            }
        });
    });

    /*
	After deleting an assignment, update the assignments list
	*/
    $('#delete_assignment').live('ajax:success', function(data, content, xhr) {
        $('#assigned_instructors').html(content);
    });

    /*
	Pricing options
	--

	When a pricing option radio button is selected,
	show the associated details list (if it exists)
	and hide other associate lists.
	*/
    $('#course_cost input[type=radio]').live('change', function() {
        var radios  = $('[name="price[cost_type]"]'),
        checked = radios.filter(':checked'),
        target  = checked.data('associate');
        radios.each(function() {
            var associate = $(this).data('associate');
            if (associate == target) {
                $(associate).show();
            } else {
                $(associate).hide();
            };
        });
    });

    /*
	Show/hide the pre-registration options
	*/
    $('#course_pre_registration_required').live('change', function() {
        $('#pre_registration').toggle();
    });


    // Submit events

    courses.course_details.find('input[type=submit]').live('click',function(event){
        event.preventDefault();
        goToStep('course_instructors');
        updateHeader();
    })


    courses.course_instructors.find('input[type=submit]').live('click',function(event){
        event.preventDefault();
        goToStep('course_cost');
        updateHeader();
    })

    courses.course_cost.find('input[type=submit]').live('click',function(event){
        event.preventDefault();
        goToStep('course_done');
        updateHeader();
    })

    if ($('#course_form').length > 0) {
        initialize();
    }
}
$(function() {
    odserv_events();
});
