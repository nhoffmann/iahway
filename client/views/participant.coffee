Template.participant.events =
  'click': (event)->
    name = $(event.target).text().trim()
    console.log name
    App.participantsController.centerParticipant(name)

Template.participant.marker = ->
  App.map.updateUserMarker(this)
