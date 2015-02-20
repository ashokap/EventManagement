# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
#

$(document).ready ->

  $("#calendar").fullCalendar(
    events: '/events.json'
    
    header: {
        left: 'prevYear,prev,today,next,nextYear'
        center: 'title',
        right: 'month,agendaWeek,agendaDay',
    }
    
    # dayClick: ->
        # alert('a day has been clicked!');
    
    eventMouseover: (data, event, view) ->
      # Todo: this function should be used to display hover than the function below
      
    eventRender: (event, element) ->
      $(element).tooltip({title: event.title + ' ' + event.description});             
    
  
    
    # eventMouseover: function(data, event, view) {
      # var content = '<h3>'+data.title+'</h3>' + 
        # '<p><b>Start:</b> '+data.start+'<br />' + 
        # (data.end && '<p><b>End:</b> '+data.end+'</p>' || '');
# 
      # tooltip.set({
        # 'content.text': content
      # })
      # .reposition(event).show(event);
    # };


  )
  
  $('#event_start_time').datetimepicker(
    minDate : 0
    format:'d-m-Y H:i'
    beforeShowDay : $.datepicker.noWeekends
  )
  
  $('#event_end_time').datetimepicker(
    minDate : 0
    format:'d-m-Y H:i'
    beforeShowDay : $.datepicker.noWeekends
  )
  
