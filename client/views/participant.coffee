Template.participant.events =
  'click': (event)->
    name = $(event.target).text().trim()
    App.participantsController.centerParticipant(name)

Template.participant.marker = ->
  App.map.updateUserMarker(this)
