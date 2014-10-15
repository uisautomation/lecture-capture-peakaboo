Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'root',
    path: '/'
    action: ->
      Router.go 'room_list', {}, {replaceState: true}
  @route 'signin',
    path: '/signin'
    layoutTemplate: 'layout-signed-out'
  @route 'users',
    path: '/users'
    template: 'accountsAdmin'
  @route 'room_list',
    path: '/room_list'
    waitOn: ->
      Meteor.subscribe 'RoomsDisplay', Session.get 'view'
  @route 'room',
    path: '/room/:_id'
    action: ->
      Router.go 'room_controls', {_id: @params._id}, {replaceState:true}
  @route 'room_controls',
    path: '/room/:_id/controls'
    template: 'room_controls'
    waitOn: ->
      Meteor.subscribe 'RoomsDisplay', Session.get 'view'
    data: ->
      room: Rooms.findOne @params._id
      controls: true
  @route 'room_repository',
    path: '/room/:_id/repository'
    template: 'room_repository'
    waitOn: ->
      Meteor.subscribe 'RoomsDisplay', Session.get 'view'
    data: ->
      room: Rooms.findOne @params._id
      repository: true

mustBeSignedIn = (pause) ->
  Router.go 'signin' if not Meteor.user() and not Meteor.loggingIn()

mustBeAdmin = (pause) ->
  Router.go 'root' if not Meteor.loggingIn() and
    not Roles.userIsInRole Meteor.userId(), ['admin']
  
Router.onBeforeAction mustBeSignedIn, except: ['signin']

Router.onBeforeAction mustBeAdmin, only: ['users']