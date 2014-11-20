Template.room_list.helpers
  room: ->
    query = Session.get 'search-query'
    filter = new RegExp query, 'i'
    Rooms.find { displayName: filter }, { sort: { displayName: 1 } }

Template.room_list.rendered = ->
  @$('[data-toggle="tooltip"]').tooltip()

Template.room_summary.helpers
  thumbnail: ->
    roomId = @_id
    timestamp = @imageTimestamp
    switch Session.get 'view'
      when 'view-screen'
        file = 'screen'
      when 'view-camera'
        file = 'presenter'
      when 'view-galicaster'
        file = 'presentation'
    url = "/image/#{roomId}/#{file}"
    if timestamp then "#{url}?#{timestamp}" else url
  zoom: ->
    Session.get 'zoom'

Template.rec.rendered = ->
  @$('[data-toggle="popover"]').popover
    placement: 'auto left'
    html: true
    container: 'body'
    content: ->
      $('#meta').html()
