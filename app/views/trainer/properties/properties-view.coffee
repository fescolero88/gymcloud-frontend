Marionette = require 'backbone.marionette'

module.exports = class PropertiesItemView extends Marionette.ItemView
  template: Templates.trainer.properties.properties_item
  tagName: 'li'

module.exports = class PropertiesView extends Marionette.CompositeView
  template: Templates.trainer.properties.properties
  childView: PropertiesItemView
  childViewContainer: 'ul'

  templateHelpers: =>
    collection: @collection

  resort: =>
    @.collection.each (model, i) =>
      model.set 'weight', i
      # Waiting for API
      # model.save()
