Template.signin.events
  'click #custom-signin': (evt, tmpl) ->
    evt.preventDefault()
    Session.set 'login.error', ''
    email = tmpl.find('#loginEmail').value
    password = tmpl.find('#loginPassword').value
    if email
      Meteor.loginWithPassword email, password, (err) ->
        switch
          when not err then Router.go '/'
          when err.error is 403
            Session.setTemp 'login.error', err.reason
          else
            Session.setTemp 'login.error', 'Unknown error'
  'click div.alert>button': (evt, tmpl) ->
    Session.set 'login.error', ''
          
Template.signin.helpers
  loginerror: ->
    Session.get 'login.error'
  
