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
  
