Marionette = require 'backbone.marionette'
PropertyModel = require 'models/trainer/property-model'

module.exports = class PropertiesView extends Marionette.LayoutView

  template: Templates.trainer.properties.properties

  collectionEvents:
    sync: 'showCollection'

  regions:
    'propertyModalView': '#property-modal'
    'propertyList': '#property-list'

  events:
    'click @ui.propertyModalBtn': 'propertyModalShow'
    'click @ui.editProperty': 'editProperty'

  ui:
    propertyModalBtn: '.add-property-btn'
    editProperty: '.gc-properties-property-edit'

  initialize: (data) ->
    @collection = data.collection
    @collectionView = data.listView

  showCollection: ->
    @propertyList.show @collectionView

  propertyModalShow: (ev) ->
    ev.preventDefault()
    model = new PropertyModel
    @propertyModalView.currentView.trigger 'showModal', {model: model, is_edit: false}

  editProperty: (ev) ->
    ev.preventDefault()
    model_id = $(ev.currentTarget).data('id')
    model = @collection.get model_id
    @propertyModalView.currentView.trigger 'showModal', {model: model, is_edit: true}
