class Map
  
  markers: {}
  locationObservers: []

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
    @updatePosition()

  center: (latitude, longitude) =>
    latlng = @latlng(latitude, longitude)
    @map.setCenter(latlng)

  updatePosition: =>
    navigator.geolocation.getCurrentPosition((position) =>
      $.each(@locationObservers, (index, method) ->
        method(position.coords.latitude, position.coords.longitude)
      )

      @center(position.coords.latitude, position.coords.longitude)
    , (error) -> 
      console.log(arguments)
    )
    
  success: (position) =>
    latlng = @latlng(position.coords.latitude, position.coords.longitude)
    $.each(@locationObservers, (index, method) ->
      method(position.coords.latitude, position.coords.longitude)
    )

    @center(position.coords.latitude, position.coords.longitude)

  error: (msg) =>
    console.log(arguments)

  addLocationObserver: (method) ->
    @locationObservers.push(method)

  removeLocationObserver: (method) ->
    locationObservers.splice(@locationObservers.indexOf(method), 1)

  drawMarkers: =>
    participants = Participants.find({mapId: Session.get('mapId')})
    console.log "Drawing markers", participants.count()
    participants.forEach( (item) =>
      @updateUserMarker(item)
    )

  removeAllMarkers: ->
    $.each(@markers, (userId, marker) ->
      marker.setMap(null)
    )
    @markers = {}

  updateUserMarker: (user) =>
    unless @markers[user._id]
      @createUserMarker(user)
    marker = @markers[user._id]
    marker.setPosition(@latlng(user.latitude, user.longitude))
    marker.setMap(@map)

  createUserMarker: (user) =>
    console.log "Creating marker for user", user
    styledMarker = new StyledMarker(
      styleIcon: new StyledIcon(StyledIconTypes.BUBBLE,{text: user.name, fore: '#ffffff', color: user.color})
      position: @latlng(user.latitude, user.longitude)
      map: @map
    )
    @markers[user._id] = styledMarker

  latlng: (latitude, longitude) ->
    new google.maps.LatLng(latitude, longitude)

window.Map = Map
