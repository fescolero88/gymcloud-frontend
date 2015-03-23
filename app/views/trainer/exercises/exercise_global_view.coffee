Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ExerciseGlobalOverviewView = require 'views/trainer/exercises/exercise_global_overview_view'

BreadcrumbsView = require 'views/general/breadcrumbs/breadcrumbs-view'
BreadcrumbsCollection = require 'models/general/breadcrumbs'

module.exports = class ExerciseGlobalView extends Marionette.LayoutView

  template: Templates.trainer.exercises.exercise_global

  regions:
    manageRegion: '#exercise-manage'
    breadcrumbsRegion: '#breadcrumbs'

  ui:
    title: '.gc-breadcrumbs-title'

  initialize: (data) =>
    @breadcrumbsView = new BreadcrumbsView
      collection: new BreadcrumbsCollection data.breadcrumbs
    @overviewView = new ExerciseGlobalOverviewView
      model: data.exercise
    @exerciseAuthor = data.exercise.get('author').id

  templateHelpers: ->
    author: @exerciseAuthor

  onShow: =>
    @manageRegion.show @overviewView
    @breadcrumbsRegion.show @breadcrumbsView
