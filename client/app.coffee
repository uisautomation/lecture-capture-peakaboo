Session.setTemp 'heartbeat', Math.round new Date().getTime() / 1000

@heartbeatInterval = Meteor.setInterval ->
  Session.setTemp 'heartbeat', Math.round new Date().getTime() / 1000
,
  10000
  
Template.registerHelper 'roomOffline', ->
  heartbeat = Template.currentData().heartbeat
  now = Session.get 'heartbeat'
  lastUpdate = now - heartbeat
  lastUpdateTime = moment.unix heartbeat
  whenAgo = lastUpdateTime.fromNow true
  whenTime = lastUpdateTime.format 'dddd, MMMM Do YYYY, HH:mm:ss'
  if lastUpdate > 15 then {ago: whenAgo, time: whenTime} else null
  
