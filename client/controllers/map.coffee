class Map
  
  markers: {}
  locationObservers: []

  constructor: ->
    if @hasGeolocation()
      @init()
      @updatePosition()
      # @drawMarkers()
    
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

  center: (latitude, longitude) =>
    latlng = @latlng(latitude, longitude)
    @map.setCenter(latlng)

  panTo: (latitude, longitude) =>
    latlng = @latlng(latitude, longitude)
    @map.panTo(latlng)    

  updatePosition: =>
    navigator.geolocation.getCurrentPosition((position) =>
      $.each(@locationObservers, (index, method) ->
        method(position.coords.latitude, position.coords.longitude)
      )

      @center(position.coords.latitude, position.coords.longitude)
    , (error) -> 
      console.log(arguments)
    )

  autoupdate: (update) ->
    if update
      @updateInterval = Meteor.setInterval @updatePosition, 10000
    else
      Meteor.clearInterval @updateInterval
    
  success: (position) =>
    latlng = @latlng(position.coords.latitude, position.coords.longitude)
    $.each(@locationObservers, (index, method) ->
      method(position.coords.latitude, position.coords.longitude)
    )

    @center(position.coords.latitude, position.coords.longitude)

  error: (msg) =>
    console.log(arguments)


  observe: (mapId) ->
    if @observerHandle?
      # kill observer if it already existed
      @observerHandle.stop()

    query = Participants.find({mapId: mapId})
    @observerHandle = query.observe
      added: (participant) =>
        @updateOrCreateUserMarker(participant)
      changed: (participant) =>
        @updateOrCreateUserMarker(participant)
      removed: (participant) =>
        @removeMarker(participant._id)

  addLocationObserver: (method) ->
    @locationObservers.push(method)

  removeLocationObserver: (method) ->
    locationObservers.splice(@locationObservers.indexOf(method), 1)

  drawMarkers: =>
    participants = Participants.find({mapId: Session.get('mapId')})
    console.log "Drawing markers", participants.count()
    participants.forEach( (item) =>
      @updateOrCreateUserMarker(item)
    )

  removeAllMarkers: ->
    $.each(@markers, (userId) =>
      @removeMarker(userId)
    )
    # @markers = {}

  removeMarker: (userId) ->
    @markers[userId].setMap(null)
    delete @markers[userId]

  updateOrCreateUserMarker: (user) =>
    if user.name?
      if @markers[user._id]
        @positionMarker(@markers[user._id], user.latitude, user.longitude)
      else
        @createUserMarker(user)    

  createUserMarker: (user) =>
    styledMarker = new StyledMarker(
      styleIcon: new StyledIcon(StyledIconTypes.BUBBLE,
        text: user.name
        fore: '#ffffff'
        color: user.color
      )
    )
    @positionMarker(styledMarker, user.latitude, user.longitude)
    @markers[user._id] = styledMarker

  positionMarker: (marker, latitude, longitude) ->
    marker.setPosition(@latlng(latitude, longitude))
    marker.setMap(@map)

  latlng: (latitude, longitude) ->
    new google.maps.LatLng(latitude, longitude)

window.Map = Map
