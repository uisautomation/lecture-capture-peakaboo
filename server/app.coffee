Meteor.startup ->
  if Meteor.users.find().fetch().length is 0
    console.log 'creating test users'

    users = [
      email: 'admin@example.com'
      password: 'admin'
      name: 'Admin'
      roles: ['admin']
    ,
      email: 'view@example.com'
      password: 'view'
      name: 'View'
      roles: ['view-rooms']
    ,
      email: 'control@example.com'
      password: 'control'
      name: 'Control'
      roles: ['control-rooms']
    ,
      email: 'galicaster@example.com'
      password: 'galicaster'
      name: 'Galicaster'
      roles: ['galicaster']
    ]

    for user in users
      id = Accounts.createUser
        email: user.email
        password: user.password
        profile:
          name: user.name

      Meteor.users.update {_id: id}, {$set: {'emails.0.verified': true}}
      Roles.addUsersToRoles id, user.roles

  Accounts.validateNewUser (user) ->
    try
      return true if isUserAuthorised @userId, ['admin', 'manage-users']
    catch
      throw new Meteor.Error 403, 'Not authorized to create new users'

Meteor.setInterval ->
  now = Meteor.call 'getServerTime'
  Rooms.update {heartbeat: {$lt: now - 15}},
    {$set: {offline: true}},
    {multi: true}
, 10000
