class ParticipantsController
  create: (name, mapId) ->
    id = Participants.insert(
      name: name
      mapId: mapId
      color: utils.getRandomColor(50,150)
      createdAt: Date.now()
    , (error, id) ->
      if error?
        console.log error 
    )
    console.log "Created user", id
    user = Participants.findOne({_id: id})
    Session.set('me', user)
    

  # updateLocation: (latlng, callback) ->

  #   Participants.update(Session.get('me')._id, 
  #     $set: 
  #       latitude: latlng.lat()
  #       longitude: latlng.lng()
  #   , (error, result) ->
  #     if error?
  #       console.log error
  #     else
  #       #Session.set('me', Participants.findOne(Session.get('me')._id))
  #       console.log "Updated user", Session.get('me'), latlng, callback
  #     if callback?
  #       callback()
  #   )

  updateLocation: (latitude, longitude) ->
    if Session.get('me')?
      Participants.update(Session.get('me')._id, 
        $set: 
          latitude: latitude
          longitude: longitude
      , (error, result) ->
        if error?
          console.log error
        else
          #Session.set('me', Participants.findOne(Session.get('me')._id))
          console.log "Updated user", Session.get('me'), latitude, longitude
      )

  centerParticipant: (name) ->
    participant = Participants.findOne({name: name, mapId: Session.get('mapId')})
    App.map.center(participant.latitude, participant.longitude)

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