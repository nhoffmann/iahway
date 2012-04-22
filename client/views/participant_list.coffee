Template.participantList.participants = ->
  if Session.get('mapId')?
    Participants.find(
      mapId: Session.get('mapId')
    )