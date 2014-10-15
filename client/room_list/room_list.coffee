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
      durationMoment = moment.unix(duration)
      durationH = durationMoment.hour()
      durationM = durationMoment.minute()
      durationHString = switch
        when durationH is 1
          '1 hour'
        when durationH > 1
          "#{durationH} hours"
        else ''
      durationMString = switch
        when durationM is 0 and durationH is 0
          'Just started...'
        when durationM is 1
          '1 minute'
        when durationM is 0 and durationH > 0
          ''
        else
          "#{durationM} minutes"
      metadata.durationDisplay = if durationHString then "#{durationHString} #{durationMString}" else "#{durationMString}"
    metadata

Template.room_summary.rendered = ->
  @$('[data-toggle="popover"]').popover
    placement: 'auto left'
    html: true
    container: 'body'
