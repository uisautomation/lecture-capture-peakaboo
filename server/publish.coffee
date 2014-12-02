Meteor.publish 'RoomsDisplay', (filters) ->
  if isUserAuthorised @userId, ['admin', 'view-rooms']
    query = {}
    if filters then for filter in filters
      switch filter
        when 'recording' then query.recording = true
        when 'idle' then query.recording = false
        when 'paused' then query.paused = true
        when 'quiet' then query.vumeter = $lte: 10
    return Rooms.find query

  @stop()


Meteor.publish 'GalicasterControl', (RoomId) ->
  if isUserAuthorised @userId, ['admin', 'galicaster']
    return Rooms.find '_id': RoomId,
      'fields':
        'screen': 0
        'presenterVideo': 0
        'presentationVideo': 0
  @stop()
