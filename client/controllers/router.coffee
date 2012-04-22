MapsRouter = Backbone.Router.extend(
  routes:
    ":map_id": "main"
 
  main: (mapId) ->
    unless mapId == ''
      Session.set "mapId", mapId

    if Session.get('mapId') && Session.get('me')
      console.log "Starting map through routing"
      App.map.locate()
    
    #   console.log mapId, Session.get('mapId'), Session.get('me')
      

 
  setMap: (mapId) ->
    if mapId?
      @navigate(mapId, true)
      
      
)

window.MapsRouter = MapsRouter