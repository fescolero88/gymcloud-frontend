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
    backButton: '.gc-content-nav-back'
    addToLibraryButton: '.gc-add-to-library-button'
    removeFromLibraryButton: '.gc-remove-from-library-button'

  events:
    'click @ui.innerNavLinks': 'changeViewEvent'
    'click @ui.backButton': 'goBack'
    'click @ui.innerNavLinks': 'changeViewEvent'
    'click @ui.addToLibraryButton': 'showAddToLibrary'
    'click @ui.removeFromLibraryButton': 'removeFromLibrary'

  initialize: (data) =>
    @breadcrumbsView = new BreadcrumbsView(collection: new BreadcrumbsCollection(data.breadcrumbs))
    @exerciseModel = data.exercise

  templateHelpers: ->
    source: @exerciseModel.get('source_item_id')
    author: @exerciseModel.get('user_id')
    public: @exerciseModel.get('is_public')
    inLibrary: @exerciseModel.get('is_in_my_library')

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
        console.debug @exerciseModel
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
    @listenToOnce @exerciseEditView, 'exercise:back', =>
      @changeView 'overview'
    @manageRegion.show @exerciseEditView

  goBack: (ev) ->
    ev.preventDefault()
    window.history.back()

  showAddToLibrary: (ev) =>
    ev.preventDefault()
    App.request 'base:addToLibraryModal', type: 'exercises', model: @exerciseModel

  removeFromLibrary: (ev) =>
    ev.preventDefault()
    copyId = $(ev.currentTarget).data('source');
    App.request 'base:confirmationalModal',
      title: "Remove exercise?"
      content: "Are you sure you want to remove this exercise from exercise?"
      confirmBtn: "Remove"
      confirmCallBack: =>
        $.ajax
          method: 'DELETE'
          url: "/api/mobile/exercises/#{copyId}"
          dataType: 'json'
          success: (model) =>
            @request 'messenger:show',
              message: 'Exercise removed from library'
