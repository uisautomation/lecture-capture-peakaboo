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
    Session.set 'modal',
      e.currentTarget.dataset
  'change .audioFaders': (e) ->
    values = {}
    values["audio.#{e.currentTarget.id}.value.left"] = e.currentTarget.value
    values["audio.#{e.currentTarget.id}.value.right"] = e.currentTarget.value
    Rooms.update { '_id': @._id }, {
      $set: values
    }, (err, result) ->
      console.log err if err
      console.log result if result

Template.controls.rendered = ->
  @$('[data-toggle="tooltip"]').tooltip()

Template.confirmModal.modal = ->
  Session.get 'modal'

Template.confirmModal.events
  'click #modalOk': (e) ->
    switch Session.get('modal').action
      when 'restart'
        Meteor.call 'restartGalicaster', @room._id
      when 'reboot'
        Meteor.call 'rebootMachine', @room._id
    $('#mymodal').modal 'hide'

Template.tableRow.mcreated = ->
  moment(@created).format("DD-MM-YYYY HH:MM")

Template.tableRow.mduration = ->
  moment(@duration * 1000).format("HH:mm:ss")
