sliderRendered = false

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
  'change input': (e) ->
    if sliderRendered
      values = {}
      input = $("input[data-slider-id='#{e.currentTarget.id}Slider']")
      level = unmap_pc input.slider 'getValue'
      values["audio.#{input.attr('id')}Level"] = level
      Rooms.update { '_id': @._id }, {
        $set: values
      }, (err, result) ->
        console.log err if err

Template.audiofader.helpers
  setSlider: (id, level) ->
    level = map_pc level
    $("##{id}").slider 'setValue', level
    level

Template.audiofader.created = ->
  sliderRendered = false
