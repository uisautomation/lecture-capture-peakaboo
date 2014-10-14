unless Session.get 'view'
  Session.set 'view', 'view-galicaster'
unless Session.get 'zoom'
  Session.set 'zoom', 3
Session.set 'search-query'

minZoom = 1
maxZoom = 4

Template.navbar.events
  'keyup input#search, click button#searchReset': (e) ->
    Session.set 'search-query', e.currentTarget.value
  'keydown input#search': (e) ->
    if e.which is 13
      e.preventDefault()
  'click #view a': (e) ->
    Session.set 'view', e.currentTarget.id
  'click #zoom button': (e) ->
    switch e.currentTarget.id
      when 'zoomOut'
        if Session.get('zoom') > minZoom
          Session.set 'zoom', Session.get('zoom') - 1
      when 'zoomIn'
        if Session.get('zoom') < maxZoom
          Session.set 'zoom', Session.get('zoom') + 1

Template.navbar.helpers
  zoomOutDisabled: ->
    Session.get('zoom') is minZoom

  zoomInDisabled: ->
    Session.get('zoom') is maxZoom

  resetDisabled: ->
    'disabled' unless Session.get('search-query')

  view: (id) ->
    Session.get('view') is id

  roomList: ->
    Router.current().route.name is 'room_list'
