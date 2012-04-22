# Create a namespace for the application
window.App = new Object()
# Create the global map object
App.map = new Map()

Router = new MapsRouter()

# hack to hide the address bar on mobile safari
window.addEventListener('load', (e) ->
  setTimeout(() ->
    window.scrollTo(0, 1)
  , 1)
, false)

# Starting up
Meteor.startup( () ->
  Backbone.history.start pushState: true
  $('.participants').hide()
  $('#name').focus()
  App.map.locate()
)