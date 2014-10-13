Template.room_list.room = ->
  query = Session.get 'search-query'
  filter = new RegExp query, 'i'
  Rooms.find { displayName: filter }, { sort: { displayName: 1 } }

Template.room_list.rendered = ->
  @$('[data-toggle="tooltip"]').tooltip()

Template.room_summary.thumbnail = ->
  switch Session.get 'view'
    when 'view-screen'
      @presentationVideo
    when 'view-camera'
      @presenterVideo
    when 'view-galicaster'
      @screen

Template.room_summary.zoom = ->
  Session.get 'zoom'
