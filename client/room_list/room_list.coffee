Template.room_list.helpers
  room: ->
    query = Session.get 'search-query'
    filter = new RegExp query, 'i'
    Rooms.find { displayName: filter }, { sort: { displayName: 1 } }

Template.room_list.rendered = ->
  @$('[data-toggle="tooltip"]').tooltip()

Template.room_summary.helpers
  thumbnail: ->
    switch Session.get 'view'
      when 'view-screen'
        @presentationVideo
      when 'view-camera'
        @presenterVideo
      when 'view-galicaster'
        @screen
  zoom: ->
    Session.get 'zoom'
  metadata: (metadata) ->
    if metadata
      created = moment.unix(metadata.created)
      metadata.createdDisplay = created.format "HH:mm"
      serverNow = Session.get 'serverTime'
      duration = serverNow - created.unix()
      metadata.duration = moment.unix(duration).format "HH:mm"
    metadata

Template.room_summary.rendered = ->
  @$('[data-toggle="popover"]').popover
    placement: 'auto right'
    html: true
