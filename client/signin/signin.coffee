Template.signin.events
  'click #custom-signin': (evt, tmpl) ->
    evt.preventDefault()
    Session.set 'login.error', ''
    Meteor.loginWithPassword tmpl.find('#loginEmail').value,
      tmpl.find('#loginPassword').value,
      (err) ->
        switch
          when not err then Router.go '/'
          when err.error is 403
            Session.setTemp 'login.error', err.reason
          else
            Session.setTemp 'login.error', 'Unknown error'
  'click div.alert>button': (evt, tmpl) ->
    Session.set 'login.error', ''
          
Template.signin.loginerror = ->
  Session.get 'login.error'
  