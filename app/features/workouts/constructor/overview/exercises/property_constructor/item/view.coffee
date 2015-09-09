define [
  'models/workout_exercise_property'
  'collections/properties'
  './template'
], (
  WorkoutExerciseProperty
  Properties
  template
) ->
  class WorkoutExercisePropertyItem extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'pull-left'

    onRender: ->
      #set default property id
      if @model.isNew()
        personal_property = @collection.at(0)
        @model.set
          personal_property_id: personal_property?.id
          personal_property: personal_property?.attributes
          property_name: personal_property?.name
        @model.personal_property = personal_property
        @ui.selectedPropertyValue.focus()

    templateHelpers: ->
      properties = @collection.toJSON()

      properties: properties
      defaultProperty: properties[0]?.name

    ui:
      removeButton: '.gc-remove'
      propertyItem: '.gc-property-item'
      selectedPropertyLabel: '.gc-selected-property'
      selectedPropertyValue: '.gc-property-value'

    events:
      'click @ui.removeButton': 'removeProperty'
      'click @ui.propertyItem': 'selectProperty'
      'keyup @ui.selectedPropertyValue': 'setPropertyValue'

    removeProperty: ->
      @model.trigger 'destroy', @model

    selectProperty: (ev) ->
      ev.preventDefault()
      id = ev.target.dataset.id
      personal_property = @collection.get(id)
      @model.set
        personal_property_id: id
        personal_property: personal_property.attributes
        property_name: personal_property.get('name')
      @ui.selectedPropertyLabel.html(ev.target.innerHTML)
      @ui.selectedPropertyValue.focus()

    setPropertyValue: (ev) ->
      @model.set('value', ev.target.innerHTML)
