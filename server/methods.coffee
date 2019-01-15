xml2js.parseStringSync = Meteor.wrapAsync xml2js.parseString

Meteor.methods
  restartGalicaster: (id) ->
    if isUserAuthorised Meteor.userId(), ['admin', 'control-rooms']
      Rooms.update { '_id': id }, {
        $set: {
          'restart': true
        }
      }

  rebootMachine: (id) ->
    if isUserAuthorised Meteor.userId(), ['admin', 'control-rooms']
      Rooms.update { '_id': id }, {
        $set: {
          'reboot': true
        }
      }

  getServerTime: ->
    Math.round new Date() / 1000

  user_ws: (userId) ->
    wsURL = Meteor.settings.user_ws.ws + userId
    picURLs = Meteor.settings.user_ws.pic_urls
    ws = HTTP.get wsURL
    res = xml2js.parseStringSync ws.content
      .formlet
    subtitle = res?.subtitle?[0]
    userName = picURL = modules = null
    if subtitle
      sub = subtitle.split '/'
      userName = sub[0].trim()
      personId = sub[1].trim()

      picURL = ''
      for url in picURLs
        url = url + personId + '.jpg'
        try
          pic = HTTP.get url
          if pic.statusCode is 200
            picURL = url
            break

      modules = []
      if res.row
        for row in res.row
          mod = {}
          for field in row.field
            mod[field.name[0]] = field.value[0]
          modules.push mod
    else
      throw new Meteor.Error 'no-user-found', 'Could not find user using web service.'

    user =
      user_id: userId
      user_name: userName
      pic_url: picURL
      modules: modules

  updateAudioLevel: (_id, channel, level) ->
    if isUserAuthorised Meteor.userId(), ['admin', 'control-rooms']
      Rooms.update { '_id': _id, 'audio.name': channel }, {
        $set: 'audio.$.level' : level
      }, (err, result) ->
        console.log err if err

  getLogins: () ->
    logins = Meteor.settings.logins
    loginMethods = []
    if logins
      for own login, settings of logins
        if settings.active
          loginMethods.push 'loginWith' + login.charAt(0).toUpperCase() +
            login.slice(1).toLowerCase()
          #console.log("Enabling auth method", login)
      if loginMethods.length == 0
        console.log "No active login mothod in the settings. Using loginWithPassword"
        loginMethods.push 'loginWithPassword'
    else
      console.log "The login method is not defined in the settings. Using loginWithPassword"
      loginMethods.push 'loginWithPassword'

    loginMethods

  getViewOnlyUsers: () ->
    allViewOnlyUser = Meteor.settings.cas.viewOnlyUsers
    if Meteor.user().username in allViewOnlyUser
      Roles.addUsersToRoles(Meteor.user(), ['view-rooms'])

  getAdminUsers: () ->
    allAdminUser = Meteor.settings.cas.adminUsers
    if Meteor.user().username in allAdminUser
      Roles.addUsersToRoles(Meteor.user(), ['admin'])

  getControlUsers: () ->
    allControlUser = Meteor.settings.cas.ControlUsers
    if Meteor.user().username in allControlUser
      Roles.addUsersToRoles(Meteor.user(), ['control-rooms'])
