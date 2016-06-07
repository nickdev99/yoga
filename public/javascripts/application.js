/* 
Apes Ruby's +require+ by loading javascript files. 

@param files(Array) A list of file names/paths
*/
$.fn.extend({
	require: function(files) {
		var base = '/javascripts/';
		
		for(i in files) {
			var file 	 = files[i],
					src  	 = base + file,
					script = $('<script type="text/javascript">').attr('src', src);

			$('head').append(script);
		}
	}
});

/* Requre Javascript files here */
$(document).require([
	'jlog.js',	
	'application/courses.js',
	'application/schedules.js',
	'application/ui.js'
]);