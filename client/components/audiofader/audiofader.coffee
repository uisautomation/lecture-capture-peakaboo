sliderRendered = false
allowUpdate = true

@map_pc = (value) ->
  min = -1650
  max = 3000
  db = ((value / 100) * (max - min)) + min
  normalized = 10 ** ((db - max) / 6000.0)
  min_norm = 10 ** ((min - max) / 6000.0)
  normalized = (normalized - min_norm) / (1 - min_norm)
  Math.round normalized * 100

log10 = (x) ->
  Math.log(x) / Math.LN10

@unmap_pc = (volume) ->
  min = -1650
  max = 3000
  volume = volume / 100
  min_norm = 10 ** ((min - max) / 6000.0)
  volume = volume * (1 - min_norm) + min_norm
  db = (6000.0 * log10(volume)) + max
  pc = Math.round ((db - min) / (max - min)) * 100

Template.audiofader.rendered = ->
  @$('[data-toggle="tooltip"]').tooltip()
  $('.fader').slider()
  sliderRendered = true

Template.audiofader.events
  'slideStart input': (e) ->
    allowUpdate = false
  'slideStop input': (e) ->
    if sliderRendered
      values = {}
      data = Template.currentData()
      level = unmap_pc Template.instance().$('input').slider 'getValue'
      _id = Template.parentData(1)._id
      Meteor.call 'updateAudioLevel', _id, data.name, level
      allowUpdate = true

Template.audiofader.helpers
  setSlider: ->
    if sliderRendered and allowUpdate
      data = Template.currentData()
      level = map_pc data.level
      Template.instance().$('input').slider 'setValue', level
    level
  faderStyle: ->
    "peakaboo-fader-#{Template.currentData().type}"

Template.audiofader.created = ->
  sliderRendered = false
