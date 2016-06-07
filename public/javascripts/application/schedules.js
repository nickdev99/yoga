/*
Schedules
--
*/
$('.schedule_date').live('ajax:success', function(status, content, xhr) {
  $('#course_form_container').html(content);
});

function shedule_initialize(){
  $('.classes_fields [name=time_span]').change(function(){
    $.post('update_time_span', {
      course_id: $(this).attr('id').split('_')[2],
      time_span: $(this).val()
    });
  });
  $('.class_name').catcomplete({
    autoFocus: true,
    source: 'class_search',
    select: function(event, ui) {
      if(ui.item.id != null) {
        var current_row = $(this).parent().parent().parent().parent().attr('id').split('_')[2]
        $('#loader_'+current_row).show(); 
        $.post('assign_class', {
          course_id: ui.item.id,
          week_day: $(this).parent().parent().parent().parent().parent().attr('id').split('_')[1],
          time_span: $('#time_span_').val(),
          current_course: current_row
          });
      }else{
        $.get('full_edit?class_name=' + $(this).val() + '&week_day=' + $('#week_day').val());
      }
    }
  });
  $('[name=instructor]').catcomplete({
    source: 'courses/instructor_search',
    autoFocus: true,
    select: function(event, ui) {
      if(ui.item.id != null) {
        $.post('assign_instructor', {
          course_id: $(this).attr('id').split('_')[1],
          instructor_id: ui.item.id
        });
        $('#loader_' + $(this).attr('id').split('_')[1]).show().fadeOut(1600);
      }else{
        $('#first_name').val($(this).val().split(' ')[0]);
        $('#last_name').val($(this).val().split(' ')[1]);
        $('#course_id').val($(this).attr('id').split('_')[1]);
        $('#dialog').dialog('open');
      }
    }
  });
  $('[name=room]').catcomplete({
    source: 'room_search',
    autoFocus: true,
    select: function(event, ui) {
      if(ui.item.id != null) {
        $.post('assign_room', {
          course_id: $(this).attr('id').split('_')[1],
          room_id: ui.item.id
        });
        $('#loader_' + $(this).attr('id').split('_')[1]).show().fadeOut(1600);
      }else{
        $('#room_name').val($(this).val());
        $('#course_id').val($(this).attr('id').split('_')[1]);
        $('#new_room').dialog('open');
      }
    }
  });
}
