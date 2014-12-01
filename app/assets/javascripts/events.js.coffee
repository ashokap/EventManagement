# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
#

$(document).ready ->

  $("#calendar").fullCalendar(
    events: '/events.json', height:500
    
    header: {
        left: 'prev,next',
        center: 'title',
        right: 'month,agendaWeek,agendaDay',
    }
  )
