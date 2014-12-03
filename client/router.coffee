Router.configure
  layoutTemplate: 'layout'

Router.route '/',
  name: 'root'
  action: ->
    Router.go 'room_list', {}, {replaceState: true}

Router.route '/signin',
  name: 'signin'
  template: 'signin'
  layoutTemplate: 'layout-signed-out'

Router.route '/users',
  name: 'users'
  template: 'accountsAdmin'

Router.route '/room_list',
  name: 'room_list'
  template: 'room_list'
  subscriptions: ->
    Meteor.subscribe 'RoomsDisplay'

Router.route /^\/room_list\/([\/\w]*)*\/?/, #'/room_list/:room_filter?',
  name: 'room_list_filter'
  template: 'room_list'
  subscriptions: ->
    Meteor.subscribe 'RoomsDisplay', @params[0].split '/'

Router.route '/room/:_id',
  name: 'room'
  action: ->
    Router.go 'room_controls', {_id: @params._id}, {replaceState:true}

Router.route '/room/:_id/controls',
  name: 'room_controls'
  template: 'room_controls'
  subscriptions: ->
    Meteor.subscribe 'RoomsDisplay'
  data: ->
    room: Rooms.findOne @params._id
    controls: true

Router.route '/room/:_id/repository',
  name: 'room_repository'
  template: 'room_repository'
  subscriptions: ->
    Meteor.subscribe 'RoomsDisplay'
  data: ->
    room: Rooms.findOne @params._id
    repository: true

mustBeSignedIn = ->
  if not Meteor.user() and not Meteor.loggingIn()
    Router.go 'signin'
  else
    @next()

mustBeAdmin = ->
  if not Meteor.loggingIn() and
  not Roles.userIsInRole Meteor.userId(), ['admin']
    Router.go 'root'
  else
    @next()

Router.onBeforeAction mustBeSignedIn, except: ['signin']

Router.onBeforeAction mustBeAdmin, only: ['users']

Router.plugin 'loading', loadingTemplate: 'Loading'
