define [
  './template'
], (
  template
) ->

  class AddCardView extends Marionette.ItemView

    tagName: 'form'

    className: 'payment-info'

    attributes: role: 'form'

    template: template

    triggers:
      'click button[type="submit"]': 'card:added'
