Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'room_list',
    path: '/'
  @route 'room',
    path: '/room/:_id'
    data: ->
      Rooms.findOne @params._id
    
