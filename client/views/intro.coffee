Template.intro.greeting = ->
  if Session.get('mapId')?
    "Join the flock"
  else
    "Create a new map"

Template.intro.events =
  'click #go' : (event) ->

    name = $('#name').val()

    $('.intro').hide()
    $('.participants').show()

    console.log "Looking up user or creating", name
    unless Session.get('mapId')?
      # create a new map
      mapName = Math.random().toString(36).substring(7);
      Maps.insert({name: mapName, createdAt: Date.now()})
      console.log "New map created", Maps.findOne({name: mapName})
      Session.set('mapId', mapName)
      Router.setMap(Session.get('mapId'))
      
    participant = Participants.findOne({name: name, mapId: Session.get('mapId')})
     
    if participant
      Session.set('me', participant)
    else
      Participants.insert(
        name: name
        mapId: Session.get('mapId')
        color: 'rgb('+utils.getRandomInt(50,150)+', '+utils.getRandomInt(50,150)+', '+utils.getRandomInt(50,150)+')'
      )
      Session.set('me', Participants.findOne({name: name}))
      #latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    
    App.map.updateParticipant()