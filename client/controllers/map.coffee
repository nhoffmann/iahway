class Map
  
  markers: {}

  constructor: ->
    if @hasGeolocation()
      @init()
    
  hasGeolocation: ->
    if navigator.geolocation
      return true
    App.router.navigate('/unsupported', true)

  # Draws a new map
  init: ->
    myOptions = {
      zoom: 15
      mapTypeControl: false
      navigationControlOptions: {style: google.maps.NavigationControlStyle.SMALL}
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    
    @map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);

  center: (latlng) =>
    @map.setCenter(latlng)

  locate: =>
    navigator.geolocation.getCurrentPosition(@success, @error)
    
  drawMarkers: =>
    participants = Participants.find({mapId: Session.get('mapId')})
    console.log "Drawing markers", participants.count()
    participants.forEach( (item) =>
      @updateMarkerForUser(item)
    )

  removeAllMarkers: ->
    $.each(@markers, (userId, marker) ->
      marker.setMap(null)
    )
    @markers = {}

  createMarkerForUser: (user) =>
    console.log "Creating marker for user", user
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(user.latitude, user.longitude), 
      map: @map, 
      title: user.name
    });
    @markers[user._id] = marker

  updateMarkerForUser: (user) =>
    unless @markers[user._id]
      @createMarkerForUser(user)
    marker = @markers[user._id]
    marker.setPosition(new google.maps.LatLng(user.latitude, user.longitude))
    marker.setMap(@map) 

  success: (position) =>
    latlng = @latlng(position.coords.latitude, position.coords.longitude)
    
    if Session.get('me')?
      App.participantsController.updateLocation(latlng, @drawMarkers)

    @center(latlng)

  latlng: (latitude, longitude) ->
    new google.maps.LatLng(latitude, longitude)

  error: (msg) =>
    console.log(arguments)

window.Map = Map
