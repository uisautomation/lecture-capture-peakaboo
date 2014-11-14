mkdirp = Meteor.npmRequire 'mkdirp'
Busboy = Meteor.npmRequire "busboy"
fs = Npm.require "fs"
os = Npm.require "os"
path = Npm.require "path"

Router.route '/image/:id',
  name: 'image'
  where: 'server'
  onBeforeAction: (req, res, next) ->
    {id} = @params
    filenames = []
    if req.method is "POST"
      busboy = new Busboy headers: req.headers
      busboy.on "file", (fieldname, file, filename, encoding, mimetype) ->
        dir = path.join Meteor.settings.imageDir, id
        mkdirp.sync dir
        saveTo = path.join dir, filename
        file.pipe fs.createWriteStream saveTo
        filenames.push saveTo
      busboy.on "field", (fieldname, value) ->
        req.body[fieldname] = value
      busboy.on "finish", ->
        req.filenames = filenames
        next()
    req.pipe busboy
.post ->
  if @request.filenames
    @response.end 'done'
  else
    @response.end 'fail'
