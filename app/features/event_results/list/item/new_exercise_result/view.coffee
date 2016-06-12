define [
  './template'
  './new_exercise_result_items/view'
  'collections/exercise_properties'
], (
  template
  NewExerciseResultItemsCollectionView
  ExerciseProperties
) ->

  class NewExerciseResultView extends Marionette.LayoutView

    className: 'workout-enter-results'

    template: template

    behaviors: ->

      regioned:
        views: [
            region: 'new_exercise_result_items'
            klass: NewExerciseResultItemsCollectionView
            options: ->
              collection: @properties
        ]

    events:
      'click .add-result-submit': 'addNewResult'

    initialize: ->
      @properties = new ExerciseProperties
      @properties.reset(@_getProperties(), parse: true)

    _getProperties: ->
      @propertiesAttributes ||= @options.properties.map (model) ->
        attrs = model.toJSON()
        property_units = model.personal_property.property_units.toJSON()
        attrs.value = attrs.value2 = 0
        attrs.personal_property.property_units = property_units
        attrs

    addNewResult: ->
      @trigger('add_new', @properties.models)
      _.defer => @properties.each((model) -> model.set(value: 0))
