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