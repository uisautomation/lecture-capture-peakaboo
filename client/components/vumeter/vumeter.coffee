Template.vumeter.meter = (vumeter) ->
  green = if vumeter % 50 < vumeter then 50 else vumeter
  yellow = if vumeter % 85 < vumeter then 35 else vumeter - 50
  red = if vumeter % 100 < vumeter then 15 else vumeter - 85
  
  'green': green
  'yellow': yellow
  'red': red
