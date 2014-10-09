@isUserAuthorised = ({userId, roles}) ->
  roles ?= []
  if userId?
    user = Meteor.users.findOne
      _id: userId
  else
    user = Meteor.user()
  
  if Roles.userIsInRole user, roles
    true
  else
    throw new Meteor.Error 403, 'Not authorised'