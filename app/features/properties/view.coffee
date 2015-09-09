define [
  'collections/user_collection'
  'models/personal_property'
  './list/view'
  'views/trainer/properties/property-modal-view'
  './template'
], (
  UserCollection
  PersonalProperty
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
      'click @ui.editProperty': 'editProperty'

    ui:
      editProperty: '.gc-properties-property-edit'

    initialize: ->
      @propertyModalView = new PropertyModalView(model: new PersonalProperty)
      @collection = App.request('current_user').personal_properties
      @collectionView = new PropertyListView(collection: @collection)

    onShow: ->
      @propertyModal.show(@propertyModalView)
      @propertyList.show(@collectionView)

    editProperty: (ev) ->
      ev.preventDefault()
      model_id = $(ev.currentTarget).data('id')
      model = @collection.get(model_id)
      @propertyModalView.trigger 'showModal',
        model: model
        is_edit: true
