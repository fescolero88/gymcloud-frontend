define [
  'collections/properties'
  './template'
], (
  Properties
  template
) ->

  class WorkoutExercisePropertyItem extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'pull-left'

    ui:
      removeButton: '.gc-remove'
      propertyItem: '.gc-dropdown li a'
      selectedPropertyLabel: '.gc-selected-property'
      selectedPropertyValue: '.gc-property-value'
      selectedPropertyValueContainer: '.gc-property-value-container'

    events:
      'click @ui.removeButton': 'removeProperty'
      'click @ui.propertyItem': 'selectProperty'
      'click @ui.selectedPropertyValueContainer' : 'setFocus'
      'keyup @ui.selectedPropertyValue': 'setPropertyValue'

    templateHelpers: ->
      properties: @properties.toJSON()
      defaultProperty: @properties.first()?.get('name')

    constructor: ->
      @properties = App.request('data:personal_properties:visible')
      super

    onRender: ->
      #set default property id
      if @model.isNew()
        personal_property = @properties.at(0)
        @model.set
          personal_property_id: personal_property?.id
          personal_property: personal_property?.attributes
          property_name: personal_property?.name
        @model.personal_property = personal_property

      setTimeout =>
        @setFocus()
      , 200

    removeProperty: ->
      @model.trigger 'destroy', @model

    selectProperty: (ev) ->
      id = ev.target.dataset.id
      personal_property = @properties.get(id)
      @model.set
        personal_property_id: id
        personal_property: personal_property.attributes
        property_name: personal_property.get('name')
      @ui.selectedPropertyLabel.html(ev.target.innerHTML)
      @ui.selectedPropertyValue.focus()

    setPropertyValue: (ev) ->
      @model.set('value', ev.target.innerHTML)

    setFocus: ->
      @ui.selectedPropertyValue.focus()
