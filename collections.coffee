@Rooms = new Meteor.Collection 'rooms'

Rooms.allow
  insert: (userId, doc) ->
    isUserAuthorised userId, ['admin', 'control-rooms', 'galicaster']
  update: (userId, doc) ->
    isUserAuthorised userId, ['admin', 'control-rooms', 'galicaster']
  remove: (userId, doc) ->
    isUserAuthorised userId, ['admin', 'control-rooms', 'galicaster']
