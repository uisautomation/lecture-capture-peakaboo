unless Session.get 'room_tab'
  Session.set 'room_tab', 'controls'

Template.room.events
  'click .peakaboo-command': (e) ->
    Session.set 'modal',
      e.currentTarget.dataset
  'click .room_tab': (e) ->
    Session.set 'room_tab', e.currentTarget.dataset.value
    
    
Template.controls.thumbnail = ->
  switch Session.get 'view'
    when 'view-screen'
      @presentationVideo
    when 'view-camera'
      @presenterVideo
    when 'view-galicaster'
      @screen

Template.controls.events
  'change .audioFaders': (e) ->
    values = {}
    values["audio.#{e.currentTarget.id}.value"] =
      'left': e.currentTarget.value
      'right': e.currentTarget.value
      
    Rooms.update { '_id': this._id }, {
      $set: values
    }, (err, result) ->
      console.log err if err
      console.log result if result

Template.confirmModal.modal = ->
  Session.get 'modal'

Template.confirmModal.events
  'click #modalOk': (e) ->
    switch Session.get('modal').action
      when 'restart'
        Meteor.call 'restartGalicaster', @_id
      when 'reboot'
        Meteor.call 'rebootMachine', @_id
    $('#mymodal').modal 'hide'

Template.room.view_tab = ->
  Template[Session.get 'room_tab']

Template.room.tab_set = (id) ->
  if Session.get('room_tab') is id
    true

Template.tableRow.mcreated = ->
  moment(@created).format("DD-MM-YYYY HH:MM")

Template.tableRow.mduration = ->
  moment(@duration * 1000).format("HH:mm:ss")
