Template.controls.events =
  'click #send': (event) ->
    event.preventDefault()
    separator = "&"
    subject = "subject=I am here! Where are you?"
    body = "body=" + window.location.href

    window.location.href = "mailto:?" + subject + separator + body

  'click #leave': (event) ->
    event.preventDefault()
    App.participantsController.destroy()

  'click #update': (event) ->
    event.preventDefault()
    App.map.updatePosition()