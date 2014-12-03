Meteor.publish 'RoomsDisplay', (filters) ->
  if isUserAuthorised @userId, ['admin', 'view-rooms']
    query = {}
    if filters
      query['$or'] = []
      for filter in filters
        switch filter
          when 'recording' then query['$or'].push recording: true
          when 'idle' then query['$or'].push recording: false
          when 'paused' then query['$or'].push paused: true
          when 'unpaused' then query['$or'].push paused: false
          when 'quiet' then query['$or'].push vumeter: $lte: 10
          when 'loud' then query['$or'].push vumeter: $gte: 10
          when 'offline' then query['$or'].push offline: true
          when 'online' then query['$or'].push offline: false
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
