mkdirp = Meteor.npmRequire 'mkdirp'
Busboy = Meteor.npmRequire "busboy"
fs = Npm.require 'fs'
os = Npm.require 'os'
path = Npm.require 'path'

Router.route '/image/:roomId',
  name: 'image'
  where: 'server'
  onBeforeAction: (req, res, next) ->
    {roomId} = @params
    filenames = []
    if req.method is 'POST'
      busboy = new Busboy headers: req.headers
      busboy.on 'file', (fieldname, file, filename, encoding, mimetype) ->
        dir = path.join Meteor.settings.imageDir, id
        try
          mkdirp.sync dir
          saveTo = path.join dir, filename
          file.pipe fs.createWriteStream saveTo
          filenames.push saveTo
        catch error
          res.statusCode = 500
          next()
      busboy.on 'finish', ->
        if filenames.length
          res.statusCode = 204
        else
          res.statusCode = 400
        next()
      req.pipe busboy
    else
      next()
.post ->
  @response.end()

Router.route '/image/:roomId/:file',
  where: 'server'
.get ->
  {roomId, file} = @params
  imagePath = path.join Meteor.settings.imageDir, id, file
  if fs.existsSync imagePath
    image = fs.readFileSync imagePath
    @response.writeHead 200,
      'Content-Type': 'image/jpg'
    @response.write image
  else
    @response.statusCode = 500
  @response.end()
