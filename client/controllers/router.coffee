MapsRouter = Backbone.Router.extend(
  routes:
    "map/:map_id": "map"
    "unsupported": "unsupported"
    "*home": "home"
 
  home: ->
    console.log "Home"
    $('.participants').hide()
    $('.intro').show()
    $('#name').focus()

  map: (mapId) ->
    Session.set "mapId", mapId
    console.log "Map", Session.get('mapId')

    if Session.get('mapId') && Session.get('me')
      console.log "Starting map through routing"
      Template.intro.showParticipants()
      console.log "Existing user", Session.get('me')
      App.map.locate()
      
  unsupported: ->
    console.log "Browser does not have the necessary features"
    # TODO show proper error screen

  setMap: (mapId) ->
    if mapId?
      @navigate('map/' + mapId, true)
      

      
)

window.MapsRouter = MapsRouter