Template.connectionStatus.helpers
  meteorStatus: ->
    Meteor.status()
  retryPc: ->
    Session.get 'offlinePc'
  retrySeconds: ->
    Session.get 'connectRetrySeconds'


Template.connectionStatus.events
  'click #connectionStatus-retry': ->
    Meteor.reconnect()

Template.connectionStatus.rendered = ->
  @autorun ->
    status = Meteor.status()

    switch status.status
      when 'connecting' then Session.setTemp 'offlinePc', '100%'
      when 'connected' then Session.setTemp 'offlinePc', '0%'

    if status.retryCount
      now = (new Date()).getTime()
      Session.setTemp 'offlineSince', now

      if @interval then  Meteor.clearInterval @interval

      min = Session.get 'offlineSince'
      max = status.retryTime
      range = max - min

      @interval = Meteor.setInterval ->
        now = (new Date()).getTime() - min
        value = (now / range) * 100
        pc = "#{value}%"
        Session.setTemp 'offlinePc', pc
        Session.setTemp 'connectRetrySeconds', Math.round((range - now) / 1000)
      , 500

    else
      if @interval
        Meteor.clearInterval @interval
        Session.setTemp 'offlineSince', null

# Template.connectionStatus.destroyed = ->
#   Meteor.clearInterval @interval
