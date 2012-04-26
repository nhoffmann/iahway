Template.intro.greeting = ->
  if Session.get('mapId')?
    "Join in!"
  else 
    "Create a new map!"

Template.intro.events =
  'submit #go' : (event) ->
    event.preventDefault()
    Template.intro.signin()

Template.intro.signin = ->
  name = $('#name').val()
  
  unless Session.get('mapId')?
    App.mapsController.create()
    
  participant = Participants.findOne({name: name, mapId: Session.get('mapId')})
  if participant
    Session.set('me', participant)
    App.map.updatePosition()
    Template.intro.showParticipants()
  else
    App.participantsController.create(name, Session.get('mapId'))
    App.router.setMap(Session.get('mapId'))

Template.intro.showParticipants = ->
  $('.intro').hide()
  $('.participants').show()
  $('.content').css('height', 'auto')

Template.intro.hideParticipants = ->
  $('.intro').show()
  $('.participants').hide()
  $('.content').css('height', '100%')