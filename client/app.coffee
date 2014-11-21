setHeartbeat = (err, res) ->
  Session.setTemp 'serverTime', res if not error?

# call once straight away and every 10 seconds thereafter
Meteor.call 'getServerTime', setHeartbeat
@heartbeatInterval = Meteor.setInterval ->
  Meteor.call 'getServerTime', setHeartbeat
, 10000
  
Template.registerHelper 'roomOffline', ->
  heartbeat = Template.currentData().heartbeat
  now = Session.get 'serverTime'
  lastUpdate = now - heartbeat
  lastUpdateTime = moment.unix heartbeat
  whenAgo = lastUpdateTime.fromNow true
  whenTime = lastUpdateTime.format 'dddd, MMMM Do YYYY, HH:mm:ss'
  if lastUpdate > 15 then {ago: whenAgo, time: whenTime} else null
  
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
  timestamp = Template.currentData().imageTimestamp
  switch Session.get 'view'
    when 'view-screen'
      file = 'screen'
    when 'view-camera'
      file = 'presenter'
    when 'view-galicaster'
      file = 'presentation'
  url = "/image/#{roomId}/#{file}"
  if timestamp then "#{url}?#{timestamp}" else url
