require 'messenger'

class GymCloudMessage extends window.Messenger.Message
    template: (opts) ->
      myTemplate = Templates.general.notify
        type: opts.type
        message: opts.message
      $(myTemplate)

window.Messenger.themes.gymcloud =
    Message: GymCloudMessage

module.exports = class MessengerHelper
  initialize: ->

    Messenger.options =
      extraClasses: 'messenger-fixed messenger-on-top messenger-on-right',
      theme: 'gymcloud'

    App.reqres.setHandler 'messenger:show', (data)->
      hideAfter = data.hideAfter ?= 3
      Messenger().post
        message: data.message
        type: data.type
        hideAfter: hideAfter
