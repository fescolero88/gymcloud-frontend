Marionette = require 'backbone.marionette'

module.exports = class PropertiesItemView extends Marionette.ItemView
  template: Templates.trainer.properties.properties_item
  tagName: 'li'

  modelEvents:
    "sync": "render"

  render: ->
    super
    @$el.data('id', @model.id)

module.exports = class PropertyListView extends Marionette.CompositeView
  template: Templates.trainer.properties.property_list
  childView: PropertiesItemView
  childViewContainer: 'ul'

  events:
    "click @ui.rmProperty": "rmProperty"

  ui:
    rmProperty: ".gc-properties-property-delete"

  templateHelpers: =>
    collection: @collection

  initialize: ->
    App.vent.on 'properties:addModel', @addProperty

  addProperty: (model)=>
    @collection.unshift model

  rmProperty: (ev)->
    ev.preventDefault()
    model_id = $(ev.currentTarget).data('id')
    model = @collection.get model_id
    model.destroy()

  onShow: ->
    @$el.find('.gc-properties-list').sortable
      handle: '.draggable-handle'
      placeholder: '<li class="placeholder sortable-placeholder"/>'
      onDrop: ($item) =>
        model_id = $item.data('id')
        model = @collection.get model_id
        $item.removeClass("dragged").removeAttr("style")
        $("body").removeClass("dragging")
        new_position = $('.gc-properties-list li').index($item)+1
        model.set 'position', new_position
        model.save()
