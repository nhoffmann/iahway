# Create a namespace for the application
window.App = new Object()

App.router = new MapsRouter()

# hack to hide the address bar on mobile safari
window.addEventListener('load', (e) ->
  Meteor.setTimeout(() ->
    window.scrollTo(0, 1)
  , 1)
, false)

# Starting up
Meteor.startup( () ->
  App.map = new Map()
  App.mapsController = new MapsController()
  App.participantsController = new ParticipantsController()

  App.map.autoupdate Session.get('autoupdate')
  App.map.addLocationObserver App.participantsController.updateLocation

  # start the routing
  Backbone.history.start pushState: true
)