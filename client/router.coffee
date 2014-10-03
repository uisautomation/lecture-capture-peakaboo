Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'room_list',
    path: '/'
  @route 'room_controls',
    path: '/room/:_id/controls'
    template: 'controls'
    data: ->
      room: Rooms.findOne @params._id
      controls: true
  @route 'room_repository',
    path: '/room/:_id/repository'
    template: 'repository'
    data: ->
      room: Rooms.findOne @params._id
      repository: true
