Meteor.startup ->

  if 'accounts' of Meteor.settings
    for user in Meteor.settings.accounts
      existing = Accounts.findUserByUsername user.username
      if existing
        console.log('Setting password for ', user.username, existing._id)
        Accounts.setPassword existing._id, user.password
      else
        console.log('Creating user ', user.username)
        id = Accounts.createUser
          username: user.username
          email: user.username
          password: user.password
          profile:
            name: user.name
        Meteor.users.update {_id: id}, {$set: {'emails.0.verified': true}}
        Roles.addUsersToRoles id, user.roles

  Accounts.validateNewUser (user) ->
    try
      return true if isUserAuthorised Meteor.userId(), ['admin', 'manage-users']
    catch
      throw new Meteor.Error 403, 'Not authorized to create new users'

Meteor.setInterval ->
  now = Meteor.call 'getServerTime'
  caTimeout = Meteor.settings.caTimeout
  Rooms.update {heartbeat: {$lt: now - caTimeout}},
    {$set: {offline: true}},
    {multi: true}
, 10000
