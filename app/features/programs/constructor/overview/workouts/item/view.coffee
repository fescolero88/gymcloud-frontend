define [
  'backbone.marionette'
  './template'
], (
  Marionette
  template
) ->
  class WorkoutItemView extends Marionette.ItemView

    template: template

    className: 'gc-workout-draggable'

    tagName: 'li'

    ui:
      workoutItemTabs: '.gc-workout-body-nav a'
      workoutTabs: '.gc-workout-tab-content'
      workoutTabPanes: '.gc-workout-tab-content .tab-pane'
      bookmark: '.gc-workout-bookmark'
      deleteWorkout: '.gc-delete-program-workout'
      workoutTitle: '.gc-workout-title > span'

    events:
      'click @ui.workoutItemTabs': 'toggleTabs'
      'click @ui.bookmark': 'toggleBookmark'
      'click @ui.deleteWorkout': 'removeProgramWorkout'
      'keypress @ui.workoutTitle': 'saveOnEnter'
      'blur @ui.workoutTitle': 'saveOnBlur'

    toggleTabs: (event) ->
      target = $(event.currentTarget)
      content = target.attr 'data-content'
      @ui.workoutItemTabs.removeClass 'active'
      target.addClass 'active'
      @changeContent content

    initialize: ->
      @model.set 'name', "Workout #{@model.collection.indexOf(@model) + 1}"

    changeContent: (content) ->
      @ui.workoutTabPanes.removeClass 'active'
      @ui.workoutTabs.find("[data-pane=#{content}]").addClass 'active'

    toggleBookmark: (event) ->
      target = $(event.currentTarget)
      if target.hasClass 'active'
        target.removeClass 'active'
      else
        target.addClass 'active'

    removeProgramWorkout: (ev) ->
      ev.preventDefault()
      @model.destroy()
      # move to .then method when api is ready
      App.request 'messenger:show',
        message: "Workout Deleted"
        type: 'success'

    saveOnEnter: (ev) ->
      if ev.which is 13
        ev.preventDefault()
        @ui.workoutTitle.blur()

    saveOnBlur: (ev) ->
      @model.set 'name', @ui.workoutTitle.text()
      @model.save()
