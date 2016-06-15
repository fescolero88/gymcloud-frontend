define [
  './item/view'
], (
  EventExerciseItemView
) ->

  class EventExerciseResultCollectionView extends Marionette.CollectionView

    className: 'gc-box-content'

    childView: EventExerciseItemView

    initialize: ->
      @listenTo(@, 'remove:results', @_removeAllResults)
      @collection = @model.exercises

    _removeAllResults: ->
      App.request 'modal:confirm',
        title: 'Remove All results?'
        content: 'Are you sure you want remove all results?'
        confirmBtn: 'Confirm'
        confirmCallBack: =>
          @children.each((view) -> view.trigger('remove:results'))
