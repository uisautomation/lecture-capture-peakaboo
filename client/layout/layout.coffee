Template.layout.rendered = ->
  @autorun =>
    fixNav()
    Session.get 'resize'

Template['layout-signed-out'].rendered = ->
  @autorun ->
    fixNav()
    Session.get 'resize'
