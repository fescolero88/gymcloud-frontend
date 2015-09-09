define [
  './template'
], (
  template
) ->

  class View extends Marionette.ItemView

    tagName: 'li'

    template: template

    bindings:
      'a':
        observe: 'name'
        attributes: [
            name: 'href'
            observe: 'href'
        ]

    onRender: ->
      _.extend(this.constructor.prototype, Backbone.Stickit.ViewMixin)
      @stickit()
      @_markAsActive()

    onDestroy: ->
      @unstickit()

    _markAsActive: ->
      if @model.get('isSelected')
        @el.classList.add('active')
