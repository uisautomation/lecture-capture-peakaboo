Connection = Meteor.npmRequire 'ssh2'

sshExec = (id, command, action, callback) ->
  room = Rooms.findOne id
  if room
    conn = new Connection()
    conn.on 'ready', ->
      conn.exec command, (err, stream) ->
        callback "Could not complete action '#{action}' on #{id}." if err
        stream.on 'exit', (code, signal) ->
          if code
            callback "Command to '#{command}' did not run successfully on #{id}."
          else
            callback null, 'Success'
    conn.on 'error', (err) ->
      callback "Could not connect to #{id} when attempting to #{action}." if err
    .connect
      host: room.ip
      port: 22
      username: Meteor.settings.auth.username
      password: Meteor.settings.auth.password

Meteor.methods
  restartGalicaster: (id) ->
    if isUserAuthorised Meteor.userId(), ['admin', 'control-rooms']
      Async.runSync (done) ->
        sshExec id, 'killall python2', 'restart galicaster', (error, result) ->
          done error, result
      
  rebootMachine: (id) ->
    if isUserAuthorised Meteor.userId(), ['admin', 'control-rooms']
      Async.runSync (done) ->
        sshExec id, 'sudo reboot', 'reboot', (error, result) ->
          done error, result
