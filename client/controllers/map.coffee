class Map
  
  markers: {}

  locate: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(@success, @error)
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
    
    @map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    @createMarkers()

  latlng: (latitude, longitude) ->
    new google.maps.LatLng(latitude, longitude)

  

  createMarkers: =>
    console.log "Setting markers for map", Session.get('mapId'), @
    Participants.find({mapId: Session.get('mapId')}).forEach( (item) =>
      console.log _this
      # marker = new google.maps.Marker({
      #   position: new google.maps.LatLng(item.latitude, item.longitude), 
      #   map: Map.map, 
      #   title: item.name
      # });
      # Map.markers[item._id] = marker

      unless @updateMarkerForUser(item)
        @createMarkerForUser(item)
    )

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
      console.log "NO marker for user yet", user
      return false
    console.log "Updating marker for user", user
    marker = @markers[user._id]
    marker.setPosition(new google.maps.LatLng(user.latitude, user.longitude))
    marker.setMap(@map)
    true
    
  updateParticipant: ->
    _this = @
    if Session.get('me')?
      Participants.update(Session.get('me')._id, 
        $set: 
          latitude: Session.get('latlng').lat()
          longitude: Session.get('latlng').lng()
      , _this.createMarkers)

      Session.set('me', Participants.findOne(Session.get('me')._id))
    

  success: (position) =>
    latlng = @latlng(position.coords.latitude, position.coords.longitude)
    console.log position.coords.latitude, position.coords.longitude, latlng
    Session.set('latlng', latlng)

    @updateParticipant()

    #Participants.update(Session.get("me")._id, {latlng: latlng})
    @create(latlng)

  error: (msg) =>
    console.log(arguments)

window.Map = Map
