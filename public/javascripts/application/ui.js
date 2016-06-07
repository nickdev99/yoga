/*
UI Effects
*/
$(document).ready(function() {
    $("#registration .2-step, #step-2-content").hide();
	
    $("#registration").parents('form').find('input[name=commit]').click(function(event){
      event.preventDefault();
      $("#registration").parents('form').submit();
    });

    $("#registration").parents('form').find('input[name=next]').click(function(event){
      event.preventDefault();
         //if ($("#registration .2-step").css('display') == 'none') {
         $("#registration .1-step, #step-1-content").hide();
         $("#registration .2-step, #step-2-content").show();
         // Submit button value
         var submitButton = $("#user_submit");
         var submitText = submitButton.attr("data-second");
         submitButton.attr("value",submitText);
         // hide studio fields if user not studio owner
         var isOwner = $("#user_user_type_2").attr("checked"),
         studioFields = $("#studio-fields");
         if (!isOwner) {
             studioFields.hide();
         }
    });
	
    // Schedule
    $(".schedule").mouseenter(function(){
        $(this).find(".editSchedule").show();
    })
    $(".schedule").mouseleave(function(){
        $(this).find(".editSchedule").hide();
    })
	
    // Studio index
    if ($(".edit_provider")) {
        $(".edit_provider").hide();
    }
	
    $("#edit-provider-name").live("click", function(){
        $(".edit_provider").show();
        $("#provider-name, #edit-provider-name").hide();
    });
	
    $(".edit_provider").bind("ajax:complete", function(){
        $(this).hide();
        var newName = $(this).find("input[type=text]").val();
        $("#provider-name")
        .show()
        .find("span")
        .html(newName);
	      
        $("#edit-provider-name").show();
    });
    // / si
	
    $("#search-box input").focus(function(){
        $(this).val(null);
    });


    $('#search-box input').autocomplete({
        autoFocus: true,
        source: '/search',
        select: function(event, ui) {
            window.location = ui.item.href
        }
    });
//  $("#search-box input").autocomplete({
//    minLength: 1,
//    delay: 600,
//    autoFocus: true,
//    source: function(request, response) {
//      $.ajax({
//        url: "/search.json",
//        dataType: "json",
//        data: {
//          term: request.term
//          },
//        success: function( data ) {
//          response( $.map( data, function( item ) {
//
//            return {
//              label: item[2],
//              value: item[0].studio.name,
//              href: "/kingston/on/"+item[1]+"/"+item[0].studio.cached_slug
//            }
//          }));
//        }
//      });
//    },
//    select: function( event, ui ) {
//      window.location = ui.item.href
//    }
//  });
	
});

