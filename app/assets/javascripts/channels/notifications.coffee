App.notificationsChannel = App.cable.subscriptions.create { channel: "NotificationsChannel" },
  connected: ->
# Called when the subscription is ready for use on the server

  disconnected: ->
# Called when the subscription has been terminated by the server

  received: (data) ->

    newNotificationElem = data

    # Add the new broadcast to the top of the list
    $("#notification_feed").prepend(newNotificationElem);

    # Send a response back to server to say received (testing purposes)
    App.notificationsChannel.send({received: navigator.userAgent})