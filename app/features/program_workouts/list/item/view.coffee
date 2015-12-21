define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    behaviors:

      stickit:
        bindings:
          '.gc-workout-title > span': 'name'
          'label input': 'is_visible'
          '.gc-description-editor': 'description'

    initialize: ->
      # debugger