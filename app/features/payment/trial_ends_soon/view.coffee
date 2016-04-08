define [
  './template'
  'moment'
], (
  template
  moment
) ->

  class TrialEndsSoonView extends Marionette.ItemView

    template: template

    className: 'center-content-flex bg-white'

    behaviors:

      stickit:
        bindings:
          '.remains':
            observe: 'subscription_end_at'
            onGet: (date) ->
              moment(date).diff(moment(), 'days') or 0

    events:

      'click .close-block': 'destroy'

    constructor: ->
      @model = App.request('current_user')
      super
