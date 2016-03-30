define [
  './template'
], (
  itemViewTpl
) ->

  class PersonalEntityItemView extends Marionette.ItemView

    template: itemViewTpl

    tagName: 'li'

    className: 'row gc-folder'

    behaviors: ->

      mobile_only_features: true

      stickit:
        bindings:
          '.name': 'name'
          '.gc-exercises-link':
            attributes: [
                name: 'href'
                observe: 'id'
                onGet: ->
                  root = _.chain(@model.type).underscore().pluralize().value()
                  "##{root}/#{@model.id}"
            ]
          '.gc-client-item-icon':
            attributes: [
                name: 'class'
                observe: 'id'
                onGet: ->
                  type = _.chain(@model.type)
                    .underscore()
                    .pluralize()
                    .value()
                  "gc-client-item-icon-#{type}"
            ]
          'span.workout':
            observe: 'workout_name'
            visible: (value) -> !!value
          '.gc-workout-link':
            observe: 'workout_name'
            attributes: [
                name: 'href'
                observe: 'workout_id'
                onGet: (value) ->
                  "#personal_workouts/#{value}"
            ]
          '.schedule-buttons':
            observe: 'id'
            visible: (value) ->
              'WorkoutExercise' isnt @model.type

    templateHelpers: =>
      isExercises: (type) =>
        'WorkoutExercise' is @model.type
