
Map = {
  locate: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(Map.success, Map.error)
    else
      error('not supported')

  create: (center) ->
    console.log "Creating map"
    myOptions = {
      zoom: 15
      center: center
      mapTypeControl: false
      navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    
    Map.map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    Map.createMarkers()

  latlng: (latitude, longitude) ->
    new google.maps.LatLng(latitude, longitude)

  createMarkers: ->
    console.log "Setting markers for map", Session.get('mapId')
    Participants.find({mapId: Session.get('mapId')}).forEach( (item) ->
      console.log item
      new google.maps.Marker({
        position: new google.maps.LatLng(item.latitude, item.longitude), 
        map: Map.map, 
        title: item.name
      });
    )

  updateParticipant: ->
    if Session.get('me')?
      Participants.update(Session.get('me')._id, 
        $set: 
          latitude: Session.get('latlng').lat()
          longitude: Session.get('latlng').lng()
      )

      Session.set('me', Participants.findOne(Session.get('me')._id))
    

  success: (position) ->
    latlng = Map.latlng(position.coords.latitude, position.coords.longitude)
    console.log position.coords.latitude, position.coords.longitude, latlng
    Session.set('latlng', latlng)

    Map.updateParticipant()

    #Participants.update(Session.get("me")._id, {latlng: latlng})
    #Map.create(latlng)

  error: (msg) ->
    console.log(arguments)

}


MapsRouter = Backbone.Router.extend(
  routes:
    ":map_id": "main"
 
  main: (mapId) ->
    unless mapId == ''
      Session.set "mapId", mapId

    if Session.get('mapId') && Session.get('me')
      console.log "Starting map through routing"
      Map.locate()
    
    #   console.log mapId, Session.get('mapId'), Session.get('me')
      

 
  setMap: (mapId) ->
    if mapId?
      @navigate(mapId, true)
      
      
)
 
Router = new MapsRouter


Meteor.startup( () ->
  Backbone.history.start pushState: true
  
  Map.locate()
)

Template.map.leMap =  ->
  leMap = Maps.findOne({name: Session.get('mapId')})
  console.log "LeMap", leMap
  #Map.locate()

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

    $('.intro').remove()

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
      )
      Session.set('me', Participants.findOne({name: name}))
      #latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    
    Map.updateParticipant()
    Map.create(Session.get('latlng'))


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
    Map.locate()

Template.status.theStatus = () ->
  Meteor.status().status
