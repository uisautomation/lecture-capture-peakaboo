mkdirp = Meteor.npmRequire 'mkdirp'
Busboy = Meteor.npmRequire 'busboy'
fs = Npm.require 'fs'
os = Npm.require 'os'
path = Npm.require 'path'

Router.route '/image/:roomId',
  name: 'image'
  where: 'server'
  onBeforeAction: (req, res, next) ->
    {roomId} = @params
    images = {}
    if req.method is 'POST'
      timestamp = Date.now()
      allowedFieldnames = ['presentation', 'presenter', 'screen']
      busboy = new Busboy headers: req.headers
      busboy.on 'file', (fieldname, file, filename, encoding, mimetype) ->
        if fieldname in allowedFieldnames
          dir = path.join Meteor.settings.imageDir, roomId
          try
            mkdirp.sync dir
            saveTo = path.join dir, filename
            file.pipe fs.createWriteStream saveTo
            images[fieldname] =
              filename: filename
              mimetype: mimetype
              timestamp: timestamp
            req.images = images
          catch error
            res.statusCode = 500
            next()
        else
          file.on 'data', ->
          file.on 'end', ->
      busboy.on 'finish', ->
        if Object.keys(images).length
          req.imageTimestamp = timestamp
          res.statusCode = 204
        else
          res.statusCode = 400
        next()
      req.pipe busboy
    else
      next()
.post ->
  if @response.statusCode is 204
    {roomId} = @params
    Rooms.update { _id: roomId }, {
      $set:
        imageTimestamp: @request.imageTimestamp
        images: @request.images
    }, (err, result) ->
      console.log err if err
  @response.end()

Router.route '/image/:roomId/:imageType(presentation|presenter|screen)',
  where: 'server'
.get ->
  if @request.cookies.meteor_login_token and Meteor.users.findOne {'services.resume.loginTokens.hashedToken': Accounts._hashLoginToken @request.cookies.meteor_login_token}
    {roomId, imageType} = @params
    
    # Find all images that are stored for the room
    room = Rooms.findOne
      _id: roomId
      images:
        $exists: true

    # Requested image
    reqImage = room?.images["#{imageType}"]

    response = @response
    redirect = ->
      response.writeHead 302, 'Location': '/images/no_image_available.png'
      response.end()

    if reqImage
      unless reqImage.filename
        redirect()
      unless reqImage.mimetype
        redirect()
      unless reqImage.timestamp
        redirect()

      # Check if requested image is stale
      if room.imageTimestamp > reqImage.timestamp
        redirect()
      
      unless @response.finished
        imagePath = path.join Meteor.settings.imageDir, roomId, reqImage.filename
        if fs.existsSync imagePath
          file = fs.readFileSync imagePath
          @response.writeHead 200,
            'Content-Type': reqImage.mimetype
          @response.write file
          @response.end()
        else
          redirect()
    else
      redirect()
  else
    @response.writeHead 403
    @response.end()
