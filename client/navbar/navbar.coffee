unless Session.get 'view'
  Session.set 'view', 'view-galicaster'
unless Session.get 'zoom'
  Session.set 'zoom', 3
Session.set 'search-query'

Template.navbar.events
  'keyup input#search, click button#searchReset': (e) ->
    Session.set 'search-query', e.currentTarget.value
  'keydown input#search': (e) ->
    if e.which is 13
      e.preventDefault()
  'click #view a': (e) ->
    Session.set 'view', e.currentTarget.id
  'change #zoom': (e) ->
    Session.set 'zoom', e.currentTarget.value

Template.navbar.resetDisabled = ->
  unless Session.get('search-query')
    'disabled'

Template.navbar.view = (id) ->
  if Session.get('view') is id
    true

Template.navbar.roomList = ->
  Router.current().route.name is 'room_list'

Template.navbar.zoom = ->
  Session.get 'zoom'
