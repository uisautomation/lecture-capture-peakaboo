Template.room_list.helpers
  rooms: ->
    searchQuery = Session.get 'search-query'
    query = {}
    query.displayName =  new RegExp searchQuery, 'i'
    Rooms.find query, { sort: { displayName: 1 } }

Template.room_list.rendered = ->
  $('.panel-title').each (index) ->
    title = $(@)
    span = title.find('[data-toggle="tooltip"]')
    span.width 'initial'
    if span.width() > title.width()
      span.width '100%'
  $('[data-toggle="tooltip"]').tooltip()

Template.room_summary.helpers
  zoom: ->
    setTimeout ->
      $('.panel-title').each (index) ->
        title = $(@)
        span = title.find('[data-toggle="tooltip"]')
        span.width 'initial'
        if span.width() > title.width()
          span.width '100%'
      $('[data-toggle="tooltip"]').tooltip()
    , .1
    Session.get 'zoom'

Template.rec.rendered = ->
  @$('[data-toggle="popover"]').each ->
    $(@).popover
      placement: 'auto left'
      html: true
      container: 'body'
      content: ->
        $(@).parent().find('.meta').html()
