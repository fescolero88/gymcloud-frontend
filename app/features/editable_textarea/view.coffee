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
          '[data-bind="description"]': 'description'

    ui:
      editor: 'textarea'

    events:
      'keyup @ui.editor': '_fixAutoHeight'
      'blur @ui.editor': '_saveAttribute'

    onBeforeRender: ->
      @model = @options.model()
      @originalModel = new Backbone.Model(@model.attributes)

    _fixAutoHeight: (area) ->
      el = @ui.editor.get(0)
      if el?.scrollHeight > el?.clientHeight
        el.style.height = "#{el.scrollHeight}px"

    _saveAttribute: (ev) ->
      $el = $(ev.currentTarget)
      attribute = $el.data('bind')
      return ev if @originalModel.get(attribute) is @model.get(attribute)

      @model.save()
        .then( (response) => @originalModel.set(response) )
        .fail( => @model.set(@originalModel.attributes) )
