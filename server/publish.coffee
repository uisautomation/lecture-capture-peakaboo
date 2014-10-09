Meteor.publish 'Rooms', ->
  Rooms.find()

Meteor.publish 'RoomsDisplay', (Display) ->
  fields = {}
  switch Display
    when 'view-galicaster'
      fields.presenterVideo = 0
      fields.presentationVideo = 0
    when 'view-camera'
      fields.screen = 0
      fields.presentationVideo = 0
    when 'view-screen'
      fields.screen = 0
      fields.presenterVideo = 0
  
  Rooms.find {}, 'fields': fields
  
Meteor.publish 'GalicasterControl', (RoomId) ->
  Rooms.find { '_id': RoomId }, 'fields': { 'screen': 0, 'presenterVideo': 0, 'presentationVideo': 0 }
