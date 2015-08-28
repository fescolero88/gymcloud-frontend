define [
  'backbone.marionette'
  'collections/user_collection'
  'models/property'
  'views/trainer/properties/property-list-view'
  'views/trainer/properties/property-modal-view'
  'templates/trainer/properties/properties'
], (
  Marionette
  UserCollection
  Property
  PropertyListView
  PropertyModalView
  template
) ->
  class PropertiesView extends Marionette.LayoutView

    template: template

    regions:
      'propertyModal': '#property-modal'
      'propertyList': '#property-list'

    events:
      'click @ui.propertyModalBtn': 'propertyModalShow'
      'click @ui.editProperty': 'editProperty'

    ui:
      propertyModalBtn: '.add-property-btn'
      editProperty: '.gc-properties-property-edit'

    initialize: ->
      @propertyModalView = new PropertyModalView(model: new Property)
      @collection = new UserCollection([], type: 'personal_properties')
      @collectionView = new PropertyListView(collection: @collection)
      @collection.fetch()

    onShow: ->
      @propertyModal.show(@propertyModalView)
      @propertyList.show(@collectionView)

    propertyModalShow: (ev) ->
      ev.preventDefault()
      model = new Property
      @propertyModalView.trigger 'showModal',
        model: model
        is_edit: false

    editProperty: (ev) ->
      ev.preventDefault()
      model_id = $(ev.currentTarget).data('id')
      model = @collection.get model_id
      @propertyModalView.trigger 'showModal',
        model: model
        is_edit: true
