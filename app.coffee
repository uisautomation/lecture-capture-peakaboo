@isUserAuthorised = (userId, roles) ->
  roles ?= []
  if userId?
    user = Meteor.users.findOne
      _id: userId
    if Roles.userIsInRole user, roles
      return true
  throw new Meteor.Error 403, 'Not authorised'
