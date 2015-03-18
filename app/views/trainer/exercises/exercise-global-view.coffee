Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ExercisesGlobalListView = require 'views/trainer/exercises/exercises-global-list-view'

AddExerciseModalView = require 'views/trainer/exercises/add-exercise-modal'
AddExerciseFolderModalView = require 'views/trainer/exercises/add-exercise-folder-modal'
DeplicateExerciseModalView = require 'views/trainer/exercises/duplicate-exercise-modal'
BreadcrumbsView = require 'views/trainer/breadcrumbs/breadcrumbs-view'
BreadcrumbsCollection = require 'models/trainer/breadcrumbs'

module.exports = class ExerciseGlobalView extends Marionette.LayoutView

  template: Templates.trainer.exercises.exercise_global

  regions:
    exercises: '#exercises-region'
    modalRegion: '#gc-modal-region'
    breadcrumbsRegion: '#breadcrumbs'

  ui:
    title: '.gc-breadcrumbs-title'

  initialize: (data) =>
    @breadcrumbsView = new BreadcrumbsView
      collection: new BreadcrumbsCollection data.breadcrumbs

  onShow: =>
    @breadcrumbsRegion.show @breadcrumbsView
