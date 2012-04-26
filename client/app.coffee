# Create a namespace for the application
window.App = new Object()

App.router = new MapsRouter()

# hack to hide the address bar on mobile safari
window.addEventListener('load', (e) ->
  setTimeout(() ->
    window.scrollTo(0, 1)
  , 1)
, false)

# Starting up
Meteor.startup( () ->
  $('.dropdown-toggle').dropdown()

  App.map = new Map()
  App.mapsController = new MapsController()
  App.participantsController = new ParticipantsController()

  App.map.addLocationObserver(App.participantsController.updateLocation)

  # start the routing
  Backbone.history.start pushState: true
)