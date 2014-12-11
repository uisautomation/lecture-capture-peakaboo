setHeartbeat = (err, res) ->
  Session.setTemp 'serverTime', res if not error?

# call once straight away and every 10 seconds thereafter
Meteor.call 'getServerTime', setHeartbeat
@heartbeatInterval = Meteor.setInterval ->
  Meteor.call 'getServerTime', setHeartbeat
, 10000

Template.registerHelper 'roomOffline', ->
  data = Template.currentData()
  offline = data.offline
  if offline
    heartbeat = data.heartbeat
    now = Session.get 'serverTime'
    lastUpdate = now - heartbeat
    lastUpdateTime = moment.unix heartbeat
    whenAgo = lastUpdateTime.fromNow true
    whenTime = lastUpdateTime.format 'dddd, MMMM Do YYYY, HH:mm:ss'
    {ago: whenAgo, time: whenTime}
  else null

Template.registerHelper 'metadata', (metadata) ->
  if metadata
    created = moment.unix(metadata.created)
    metadata.createdDisplay = created.format "HH:mm"
    serverNow = Session.get 'serverTime'
    duration = serverNow - created.unix()
    duration = 0 if duration < 0
    durationMoment = moment.unix(duration)
    durationH = durationMoment.hour()
    durationM = durationMoment.minute()
    durationHString = switch
      when durationH is 1
        '1 hour'
      when durationH > 1
        "#{durationH} hours"
      else ''
    durationMString = switch
      when durationM is 0 and durationH is 0
        'Just started...'
      when durationM is 1
        '1 minute'
      when durationM is 0 and durationH > 0
        ''
      else
        "#{durationM} minutes"
    metadata.durationDisplay = if durationHString then "#{durationHString} #{durationMString}" else "#{durationMString}"
    if metadata.series_identifier
      metadata.series_identifier = metadata.series_identifier.replace '__', ':'
  metadata

Template.registerHelper 'screen', (profile) ->
  true if profile is 'cam' or profile is 'nocam'

Template.registerHelper 'cam', (profile) ->
  true if profile is 'cam'

Template.registerHelper 'thumbnail', ->
  roomId = Template.currentData()._id
  timestamp = Template.currentData().heartbeat
  images = Template.currentData().images
  switch Session.get 'view'
    when 'view-screen'
      file = 'presentation'
    when 'view-camera'
      file = 'presenter'
    when 'view-galicaster'
      file = 'screen'

  if images?[file]
    "/image/#{roomId}/#{file}?#{timestamp}"
  else
    '/images/no_image_available.png'

fireAnim = (element, anim) ->
  events = 'webkitAnimationEnd mozAnimationEnd ' +
           'MSAnimationEnd oanimationend animationend'
  element.removeClass(anim).addClass(anim).one events , ->
    element.removeClass anim
