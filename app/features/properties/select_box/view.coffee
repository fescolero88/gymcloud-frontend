define [
  './template'
  './item/view'
  'models/personal_property'
], (
  template
  ItemView
  PersonalProperty
) ->

  class PropertiesSelectBoxView extends Marionette.CompositeView

    className: 'btn-group'

    attributes:
      role: 'group'

    template: template

    childView: ItemView

    childViewContainer: 'ul'

    childEvents:
      'selected': 'triggerOptionSelected'

    behaviors:
      stickit:
        bindings:
          '.gc-selected-property': 'name'

    initialize: ->
      @collection = App.request('data:personal_properties:visible')
      @model = new PersonalProperty(@collection.first()?.attributes)

    triggerOptionSelected: (childView) ->
      @model.set(childView.model.attributes)
      @trigger('selected', childView.model.id)