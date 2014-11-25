Meteor.publish 'RoomsDisplay', ->
  if isUserAuthorised @userId, ['admin', 'view-rooms']
    return Rooms.find {}

  @stop()


Meteor.publish 'GalicasterControl', (RoomId) ->
  if isUserAuthorised @userId, ['admin', 'galicaster']
    return Rooms.find '_id': RoomId,
      'fields':
        'screen': 0
        'presenterVideo': 0
        'presentationVideo': 0
  @stop()
