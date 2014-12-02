Template.room_list.helpers
  rooms: ->
    searchQuery = Session.get 'search-query'
    query = {}
    query.displayName =  new RegExp searchQuery, 'i'
    if Template.currentData().offlineTime
      query.heartbeat = $lt: Template.currentData().offlineTime
    Rooms.find query, { sort: { displayName: 1 } }

Template.room_list.rendered = ->
  @$('[data-toggle="tooltip"]').tooltip()

Template.room_summary.helpers
  zoom: ->
    Session.get 'zoom'

Template.rec.rendered = ->
  @$('[data-toggle="popover"]').popover
    placement: 'auto left'
    html: true
    container: 'body'
    content: ->
      $('#meta').html()
