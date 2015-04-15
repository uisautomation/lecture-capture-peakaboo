Template.room_list.helpers
  rooms: ->
    searchQuery = Session.get 'search-query'
    query = {}
    query.displayName =  new RegExp searchQuery, 'i'
    Rooms.find query, { sort: { displayName: 1 } }

Template.room_summary.rendered = ->
  @autorun =>
    Session.get 'zoom'
    offline = Template.currentData().offline
    resizePanelTitle()

Template.room_summary.helpers
  zoom: ->
    Session.get 'zoom'

Template.rec.rendered = ->
  @$('[data-toggle="popover"]').each ->
    $(@).popover
      placement: 'auto left'
      html: true
      container: 'body'
      content: ->
        $(@).parent().find('.meta').html()
