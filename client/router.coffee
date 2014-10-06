Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'root',
    path: '/'
    action: ->
      @redirect '/room_list'
  @route 'room_list',
    path: '/room_list'
  @route 'room',
    path: '/room/:_id'
    action: ->
      @redirect "/room/#{@params._id}/controls"
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
