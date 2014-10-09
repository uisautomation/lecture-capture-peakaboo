Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'root',
    path: '/'
    action: ->
      @redirect '/room_list'
  @route 'signin',
    path: '/signin'
    layoutTemplate: 'layout-signed-out'
  @route 'room_list',
    path: '/room_list'
    waitOn: ->
      Meteor.subscribe 'RoomsDisplay', Session.get 'view'
  @route 'room',
    path: '/room/:_id'
    action: ->
      @redirect "/room/#{@params._id}/controls"
  @route 'room_controls',
    path: '/room/:_id/controls'
    template: 'controls'
    waitOn: ->
      Meteor.subscribe 'RoomsDisplay', Session.get 'view'
    data: ->
      room: Rooms.findOne @params._id
      controls: true
  @route 'room_repository',
    path: '/room/:_id/repository'
    template: 'repository'
    waitOn: ->
      Meteor.subscribe 'RoomsDisplay', Session.get 'view'
    data: ->
      room: Rooms.findOne @params._id
      repository: true

mustBeSignedIn = (pause) ->
  Router.go('signin') if not Meteor.user() and not Meteor.loggingIn()
  
Router.onBeforeAction mustBeSignedIn, except: ['signin']