class MapsController
  # Create a new map in database and return its random name string.
  create: ->
    mapName = Math.random().toString(36).substring(7);
    Maps.insert({name: mapName, createdAt: Date.now()})
    Session.set('mapId', mapName)
    mapName

window.MapsController = MapsController