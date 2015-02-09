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

    if @interval then Meteor.clearInterval @interval
    
    switch status.status
      when 'connecting'
        Session.setTemp 'offlinePc', '100%'
      when 'connected'
        Session.setTemp 'offlinePc', '0%'
        delete Session.keys['connectRetrySeconds']
      when 'waiting'
        min = Date.now()
        max = status.retryTime
        range = max - min

        @interval = Meteor.setInterval ->
          now = Date.now() - min
          value = (now / range) * 100
          Session.setTemp 'offlinePc', "#{value}%"
          Session.setTemp 'connectRetrySeconds', Math.round (range - now) / 1000
        , 500
    setTimeout ->
      resize()
    , 50
