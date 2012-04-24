MapsRouter = Backbone.Router.extend(
  routes:
    "map/:map_id": "map"
    "unsupported": "unsupported"
    "*home": "home"
 
  home: ->
    console.log "Home"
    $('.participants').hide()
    $('#formWrapper').show()
    $('#name').focus()

  map: (mapId) ->
    Session.set "mapId", mapId

    if Session.get('mapId') && Session.get('me')
      console.log "Existing user", Session.get('me')
      App.map.updatePosition()
      Template.intro.showParticipants()
      
  unsupported: ->
    console.log "Browser does not have the necessary features"
    # TODO show proper error screen

  setMap: (mapId) ->
    if mapId?
      console.log "Setting map in router", mapId
      @navigate('map/' + mapId, true)
)

window.MapsRouter = MapsRouter