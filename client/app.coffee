map = new Map()

window.addEventListener('load', (e) ->
  setTimeout(() ->
    window.scrollTo(0, 1)
  , 1)
, false)


MapsRouter = Backbone.Router.extend(
  routes:
    ":map_id": "main"
 
  main: (mapId) ->
    unless mapId == ''
      Session.set "mapId", mapId

    if Session.get('mapId') && Session.get('me')
      console.log "Starting map through routing"
      map.locate()
    
    #   console.log mapId, Session.get('mapId'), Session.get('me')
      

 
  setMap: (mapId) ->
    if mapId?
      @navigate(mapId, true)
      
      
)
 
Router = new MapsRouter


Meteor.startup( () ->
  Backbone.history.start pushState: true
  $('.participants').hide()
  $('#name').focus()
  map.locate()
)

Template.participantList.participants = ->
  if Session.get('mapId')?
    Participants.find(
      mapId: Session.get('mapId')
    )


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
    
    map.updateParticipant()


Template.controls.events =
  'click #leave': (event) ->
    Participants.remove(Session.get('me')._id, (error) ->
      if error
        console.log error
      else
        window.location = "/"
    )
    #window.location = "/"

  'click #update': (event) ->
    console.log "update location"
    map.locate()

Template.status.theStatus = () ->
  Meteor.status().status



