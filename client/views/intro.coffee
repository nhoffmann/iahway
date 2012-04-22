Template.intro.greeting = ->
  if Session.get('mapId')?
    "Join the flock"
  else
    "Create a new map"

Template.intro.events =
  'submit #go' : (event) ->
    event.preventDefault()
    Template.intro.signin()

Template.intro.signin = ->
  name = $('#name').val()

  console.log "Looking up user or creating", name
  
  unless Session.get('mapId')?
    App.mapsController.create()
    
  participant = Participants.findOne({name: name, mapId: Session.get('mapId')})
  if participant
    console.log "Found participant", participant
    Session.set('me', participant)
  else
    App.participantsController.create(name, Session.get('mapId'))
    
  
  App.map.locate()
  Template.intro.showParticipants()

Template.intro.showParticipants = ->
  $('.intro').hide()
  $('.participants').show()
  $('.content').css('height', 'auto')