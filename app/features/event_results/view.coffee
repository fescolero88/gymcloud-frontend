define [
  './template'
  './event_exercises/view'
  './comments/view'
], (
  template
  EventExerciseCollectionView
  CommentsLayoutView
) ->

  class EventExerciseLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-box-content'

    behaviors: ->

      regioned:
        views: [
            region: 'event_exercises'
            klass: EventExerciseCollectionView
            options: ->
              collection: @model.exercises
          ,
            region: 'comments'
            klass: CommentsLayoutView
            options: ->
              collection: @model.comments
        ]

    events:
      'click .type-delete': '_removeAllResults'

    _removeAllResults: ->
      @views.event_exercises.trigger('remove:results')
