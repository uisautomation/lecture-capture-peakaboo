Template.room_list.helpers
  room: ->
    query = Session.get 'search-query'
    filter = new RegExp query, 'i'
    Rooms.find { displayName: filter }, { sort: { displayName: 1 } }

Template.room_list.rendered = ->
  @$('[data-toggle="tooltip"]').tooltip()
  @$('[data-toggle="popover"]').each ->
    $(@).popover
      placement: 'auto left'
      html: true
      container: 'body'
      content: ->
        $(@).parent().find('.meta').html()

Template.room_summary.helpers
  zoom: ->
    Session.get 'zoom'
