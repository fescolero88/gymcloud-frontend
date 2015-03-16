Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ExercisesGlobalListView = require 'views/trainer/exercises/exercises-global-list-view'

AddExerciseModalView = require 'views/trainer/exercises/add-exercise-modal'
AddExerciseFolderModalView = require 'views/trainer/exercises/add-exercise-folder-modal'
DeplicateExerciseModalView = require 'views/trainer/exercises/duplicate-exercise-modal'

module.exports = class ExerciseGlobalView extends Marionette.ItemView

  template: Templates.trainer.exercises.exercise_global

  regions:
    exercises: '#exercises-region'
    modalRegion: '#gc-modal-region'

  ui:
    title: '.gc-breadcrumbs-title'

  initialize: (data) =>
    @breadcrumbs = data.breadcrumbs

  onShow: =>
    @updateBreadcrumbs @breadcrumbs

  updateBreadcrumbs: (breadcrumbs) =>
    @ui.title.text('')
    $.each breadcrumbs, (index, value) =>
      @ui.title.append $("<span>#{value}</span>")
