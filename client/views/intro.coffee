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
    App.map.updatePosition()
    Template.intro.showParticipants()
  else
    console.log "Creating new participant"
    App.participantsController.create(name, Session.get('mapId'))
    
    #Session.set('me', )
    console.log "Created user", Session.get('me')
    App.router.setMap(Session.get('mapId'))

Template.intro.showParticipants = ->
  $('#formWrapper').hide()
  $('.participants').show()
  $('.content').css('height', 'auto')