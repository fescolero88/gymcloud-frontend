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
    publicMarker: '.gc-privacy-public'
    privateMarker: '.gc-privacy-private'

  initialize: (data) =>
    @breadcrumbsView = new BreadcrumbsView
      collection: new BreadcrumbsCollection data.breadcrumbs
    @overviewView = new ExerciseGlobalOverviewView
      model: data.exercise

    @exerciseAuthor = data.exercise.get('author').id
    @isPublic = data.exercise.get('is_public')

    @listenTo @overviewView, 'privacy:changed', @changePrivacyMarker

  templateHelpers: ->
    author: @exerciseAuthor
    public: @isPublic

  onShow: =>
    @manageRegion.show @overviewView
    @breadcrumbsRegion.show @breadcrumbsView

  changePrivacyMarker: (isPublic) =>
    if isPublic
      @ui.privateMarker.addClass('hide')
      @ui.publicMarker.removeClass('hide')
    else
      @ui.publicMarker.addClass('hide')
      @ui.privateMarker.removeClass('hide')
