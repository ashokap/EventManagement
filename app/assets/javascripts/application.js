// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
//= require jquery.datetimepicker
//= require jquery.datetimepicker/init
//= require turbolinks
//= require fullcalendar
//= require_tree 

$(function() {

	$('#event_start_time').datetimepicker({
		minDate : 0
	});
	$('#event_end_time').datetimepicker({
		minDate : 0
	});

	$('#event_start_time').datetimepicker({
		beforeShowDay : $.datepicker.noWeekends
	});
	$('#event_end_time').datetimepicker({
		beforeShowDay : $.datepicker.noWeekends
	});

	
	//To enable tooltip for any  kind of HTML element
	$("[data-toggle='tooltip']").tooltip();
	
	
});
