class AudioFader

  constructor: ->
    @tmpl = Template.instance()
    @sliderRendered = false
    @allowUpdate = true

  setLevel: (level) ->
    if @sliderRendered and @allowUpdate
      level = @_mapValue level
      @tmpl.$('input').slider 'setValue', level
    level

  getLevel: ->
    slider = @tmpl.$('input').slider 'getValue'
    @_unmapValue slider

  saveLevel: ->
    _id = Template.parentData(1)._id
    Meteor.call 'updateAudioLevel', _id, @tmpl.data.name, @getLevel()
    @allowUpdate = true

  slideStart: ->
    @allowUpdate = false

  slideStop: ->
    @saveLevel()

  rendered: ->
    @tmpl.$('.fader').slider()
    @sliderRendered = true
    @setLevel @tmpl.data.level

  _mapValue: (value) ->
    max = @tmpl.data.max
    min = @tmpl.data.min
    db = ((value / 100) * (max - min)) + min
    normalized = 10 ** ((db - max) / 6000.0)
    min_norm = 10 ** ((min - max) / 6000.0)
    normalized = (normalized - min_norm) / (1 - min_norm)
    Math.round normalized * 100

  _unmapValue: (volume) ->
    max = @tmpl.data.max
    min = @tmpl.data.min
    volume = volume / 100
    min_norm = 10 ** ((min - max) / 6000.0)
    volume = volume * (1 - min_norm) + min_norm
    db = (6000.0 * log10(volume)) + max
    Math.round ((db - min) / (max - min)) * 100


log10 = (x) ->
  Math.log(x) / Math.LN10

Template.audiofader.created = ->
  @audiofader = new AudioFader

Template.audiofader.rendered = ->
  @audiofader.rendered()

Template.audiofader.destroyed = ->
  @audiofader = null

Template.audiofader.events
  'slideStart input': (e) ->
    Template.instance().audiofader.slideStart()
  'slideStop input': (e) ->
    Template.instance().audiofader.slideStop()

Template.audiofader.helpers
  faderStyle: ->
    "peakaboo-fader-#{Template.currentData().type}"
