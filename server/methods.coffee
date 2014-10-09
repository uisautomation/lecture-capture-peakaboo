Connection = Meteor.npmRequire 'ssh2'

sshexec = (id, command) ->
  room = Rooms.findOne id
  if room
    conn = new Connection()
    conn.on 'ready', ->
      conn.exec command, (err, stream) ->
        console.log err if err
        stream.on 'exit', (code, signal) ->
          if code
            console.log "Could not exec '#{command}' on '#{id}'"
    conn.on 'error', (err) ->
      console.log err
    .connect
      host: room.ip
      port: 22
      username: Meteor.settings.auth.username
      password: Meteor.settings.auth.password

Meteor.methods
  restartGalicaster: (id) ->
    if isUserAuthorised Meteor.userId(), ['admin', 'control-rooms']
      sshexec id, 'killall python2'
      
  rebootMachine: (id) ->
    if isUserAuthorised Meteor.userId(), ['admin', 'control-rooms']
      sshexec id, 'sudo reboot'
