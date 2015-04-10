Template.room_list.helpers
  rooms: ->
    searchQuery = Session.get 'search-query'
    query = {}
    query.displayName =  new RegExp searchQuery, 'i'
    Rooms.find query, { sort: { displayName: 1 } }

Template.room_summary.rendered = ->
  title = @$('.panel-title')
  span = title.find '[data-toggle="tooltip"]'
  @autorun ->
    offline = Template.currentData().offline
    span.width 'initial'
    if span.width() > title.width()
      span.width '100%'
    setTimeout ->
      span.tooltip('fixTitle')
    , 50

Template.room_summary.helpers
  zoom: ->
    setTimeout ->
      $('.panel-title').each (index, element) ->
        title = $(element)
        span = title.find('[data-toggle="tooltip"]')
        span.width 'initial'
        if span.width() > title.width()
          span.width '100%'
    , 50
    Session.get 'zoom'

Template.rec.rendered = ->
  @$('[data-toggle="popover"]').each ->
    $(@).popover
      placement: 'auto left'
      html: true
      container: 'body'
      content: ->
        $(@).parent().find('.meta').html()
