Template.room.events
  'click .peakaboo-command': (e) ->
    data = e.currentTarget.dataset
    Session.set 'modal',
      data
    
    
Template.room.thumbnail = ->
  switch Session.get 'view'
    when 'view-screen'
      @presentationVideo
    when 'view-camera'
      @presenterVideo
    when 'view-galicaster'
      @screen

Template.room.events
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
