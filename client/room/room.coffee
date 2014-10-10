Template.controls.thumbnail = ->
  switch Session.get 'view'
    when 'view-screen'
      @presentationVideo
    when 'view-camera'
      @presenterVideo
    when 'view-galicaster'
      @screen

Template.controls.events
  'click .peakaboo-command': (e) ->
    ###
    Should unsetting the command-error session be done somewhere better than
    click of a command button to clear any command error messages from UI?
    ###
    Session.set 'command-error', ''
    Session.set 'modal',
      e.currentTarget.dataset
  'change .audioFaders': (e) ->
    values = {}
    values["audio.#{e.currentTarget.id}.value.left"] = e.currentTarget.value
    values["audio.#{e.currentTarget.id}.value.right"] = e.currentTarget.value
    Rooms.update { '_id': @room._id }, {
      $set: values
    }, (err, result) ->
      console.log err if err
      console.log result if result

Template.confirmModal.modal = ->
  Session.get 'modal'

Template.confirmModal.commandError = ->
  Session.get 'command-error'

Template.confirmModal.events
  'click #modalOk': (e) ->
    switch Session.get('modal').action
      when 'restart'
        Meteor.call 'restartGalicaster', @room._id, (error, result) ->
          # When does error occur?
          if result.error
            Session.set 'command-error', result.error
          else
            $('#mymodal').modal 'hide'
      when 'reboot'
        Meteor.call 'rebootMachine', @room._id, (error, result) ->
          # When does error occur?
          if result.error
            Session.set 'command-error', result.error
          else
            $('#mymodal').modal 'hide'

Template.tableRow.mcreated = ->
  moment(@created).format("DD-MM-YYYY HH:MM")

Template.tableRow.mduration = ->
  moment(@duration * 1000).format("HH:mm:ss")
