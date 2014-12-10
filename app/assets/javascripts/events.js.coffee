# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
#

$(document).ready ->

  $("#calendar").fullCalendar(
    events: '/events.json'
    
    header: {
        left: 'today'
        center: 'prevYear,prev,title,next,nextYear',
        right: 'month,agendaWeek,agendaDay',
    }
    # ,
    # eventMouseover: function(data, event, view) {
      # var content = '<h3>'+data.title+'</h3>' + 
        # '<p><b>Start:</b> '+data.start+'<br />' + 
        # (data.end && '<p><b>End:</b> '+data.end+'</p>' || '');
# 
      # tooltip.set({
        # 'content.text': content
      # })
      # .reposition(event).show(event);
    # }


  )
  
