define [
  'backbone.marionette'
  'backbone'
  './template'
], (
  Marionette
  Backbone
  template
) ->

  class EntityItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    ui:
      checkbox: '.gc-exercises-chb input'

    events:
      'click @ui.checkbox': 'itemChecked'

    bindings:
      '[data-bind="name"]': 'name'
      '[data-bind="updated_at"]': 'updated_at'

    initialize: (options) =>
      @type = options.type

    templateHelpers: ->
      type: @type
      isFolder: !@model.get('folder_id')
      url: do =>
        if @model.get('folder_id')
          "##{@type}/#{@model.get('id')}"
        else
          "##{@type}_folder/#{@model.get('id')}"

    onRender: ->
      @stickit()

    onDestroy: ->
      @unstickit()

    itemChecked: (ev) =>
      @trigger 'item:clicked'