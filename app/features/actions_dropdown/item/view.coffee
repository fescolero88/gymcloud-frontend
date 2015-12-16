define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    events:
      'click': '_triggerAction'

    _triggerAction: ->
      @model.get('action')?()
