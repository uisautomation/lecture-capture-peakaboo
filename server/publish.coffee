Meteor.publish 'RoomsDisplay', (Display) ->
  if isUserAuthorised @userId, ['admin', 'view-rooms']
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
  
    return Rooms.find {}, 'fields': fields
  
  @stop()
  
  
Meteor.publish 'GalicasterControl', (RoomId) ->
  if isUserAuthorised @userId, ['admin', 'galicaster']
    return Rooms.find '_id': RoomId,
      'fields':
        'screen': 0
        'presenterVideo': 0
        'presentationVideo': 0
  @stop()
