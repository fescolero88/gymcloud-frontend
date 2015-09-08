define [
  'backbone'
  'backbone.marionette'
  './template'
], (
  Backbone
  Marionette
  template
) ->

  class View extends Marionette.ItemView

    tagName: 'label'

    className: 'btn btn-primary'

    template: template

    bindings:
      'input':
        attributes: [
          name: 'value'
          observe: 'value'
        ]

      'span': 'name'

    onRender: ->
      _.extend(this.constructor.prototype, Backbone.Stickit.ViewMixin)
      @stickit()
      @_markAsActive()

    onDestroy: ->
      @unstickit()

    _markAsActive: ->
      if @model.get('inScope')
        @el.classList.add 'active'
