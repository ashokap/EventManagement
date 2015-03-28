# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
#

$(document).ready ->
  
  $('#case_starting_date').datetimepicker(
    timepicker: false
    minDate: 0
    format:'d-m-Y'
    beforeShowDay : $.datepicker.noWeekends
    autoclose: true
  )
  
  $('#case_ending_date').datetimepicker(
    timepicker: false
    minDate: 0
    format:'d-m-Y'
    beforeShowDay : $.datepicker.noWeekends
  )
  $('#case_next_hearing').datetimepicker(
    timepicker: false
    minDate: 0
    format:'d-m-Y'
    beforeShowDay : $.datepicker.noWeekends
  )
