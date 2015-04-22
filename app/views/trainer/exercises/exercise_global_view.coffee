Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ExerciseGlobalOverviewView = require 'views/trainer/exercises/exercise_global_overview_view'
ExerciseGlobalAssignView = require 'views/trainer/exercises/exercise_global_assign_view'

ExerciseEditView = require 'views/trainer/exercises/exercise_edit_view'

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
    innerNavItems: '.gc-content-nav li'
    innerNavLinks: '.gc-content-nav li a'

  events:
    'click @ui.innerNavLinks': 'changeViewEvent'

  initialize: (data) =>
    @breadcrumbsView = new BreadcrumbsView(collection: new BreadcrumbsCollection(data.breadcrumbs))
    @exerciseModel = data.exercise

    @exerciseAuthor = data.exercise.get('author').id
    @isPublic = data.exercise.get('is_public')

  templateHelpers: ->
    author: @exerciseAuthor
    public: @isPublic

  onShow: =>
    @changeView 'overview'
    @breadcrumbsRegion.show @breadcrumbsView

  changePrivacyMarker: (isPublic) =>
    if isPublic
      @ui.privateMarker.addClass('hide')
      @ui.publicMarker.removeClass('hide')
    else
      @ui.publicMarker.addClass('hide')
      @ui.privateMarker.removeClass('hide')

  changeViewEvent: (ev) =>
    ev.preventDefault()
    navItem = $(ev.currentTarget).parent()
    if not $(navItem).hasClass 'active'
      @ui.innerNavItems.removeClass 'active'
      $(navItem).addClass 'active'
      navItemView = $(navItem).data 'view'
      @changeView navItemView

  changeView: (navView) =>
    switch navView
      when 'overview'
        @overviewView = new ExerciseGlobalOverviewView model: @exerciseModel
        @listenTo @overviewView, 'privacy:changed', @changePrivacyMarker
        @listenTo @overviewView, 'exercise:edit', @enableExerciseEditView
        @manageRegion.show @overviewView
      when 'video'
        true
      when 'assign'
        @assignView = new ExerciseGlobalAssignView model: @exerciseModel
        @manageRegion.show @assignView

  enableExerciseEditView: =>
    @exerciseEditView = new ExerciseEditView model: @exerciseModel
    @listenTo @exerciseEditView, 'exercise:back', =>
      @changeView 'overview'
    @manageRegion.show @exerciseEditView
