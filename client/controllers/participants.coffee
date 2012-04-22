class ParticipantsController
  create: (name, mapId, callback) ->
    id = Participants.insert(
      name: name
      mapId: mapId
      color: 'rgb('+utils.getRandomInt(50,150)+', '+utils.getRandomInt(50,150)+', '+utils.getRandomInt(50,150)+')'
    , (error, id) ->
      if error?
        console.log error 
    )
    Session.set('me', Participants.findOne({name: name, mapId: mapId}))
    console.log "Created user", Session.get('me')
    App.router.setMap(Session.get('mapId'))
    if callback?
      callback()

  updateLocation: (latlng, callback) ->

    Participants.update(Session.get('me')._id, 
      $set: 
        latitude: latlng.lat()
        longitude: latlng.lng()
    , (error, result) ->
      if error?
        console.log error
      else
        #Session.set('me', Participants.findOne(Session.get('me')._id))
        console.log "Updated user", Session.get('me'), latlng, callback
      if callback?
        callback()
    )

  centerParticipant: (name) ->
    participant = Participants.findOne({name: name, mapId: Session.get('mapId')})
    latlng = App.map.latlng(participant.latitude, participant.longitude)
    App.map.center(latlng)

    # Removes a user from the map and routes her back to home
  destroy: ->
    Participants.remove(Session.get('me')._id, (error) =>
      if error
        console.log error
      else
        App.map.removeAllMarkers()
        Session.set('mapId', undefined)
        App.router.navigate("/", true)
    )

window.ParticipantsController = ParticipantsController