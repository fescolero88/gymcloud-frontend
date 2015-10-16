ExerciseGlobalOverviewView = require 'views/trainer/exercises/exercise_global_overview_view'
ExerciseGlobalAssignView = require 'views/trainer/exercises/exercise_global_assign_view'
ExerciseGlobalAssignVideoView = require 'views/trainer/exercises/exercise_global_assign_video_view'

ExerciseEditView = require 'views/trainer/exercises/exercise_edit_view'

# BreadcrumbsView = require 'views/general/breadcrumbs/breadcrumbs-view'

module.exports = class ExerciseGlobalView extends Marionette.LayoutView

  template: require('templates/trainer/exercises/exercise_global')

  regions:
    manageRegion: '#exercise-manage'
    breadcrumbsRegion: '#breadcrumbs'

  ui:
    title: '.gc-breadcrumbs-title'
    publicMarker: '.gc-privacy-public'
    privateMarker: '.gc-privacy-private'
    innerNavItems: '.gc-content-nav li'
    innerNavLinks: '.gc-content-nav li a'
    addToLibraryButton: '.gc-add-to-library-button'
    removeFromLibraryButton: '.gc-remove-from-library-button'

  events:
    'click @ui.innerNavLinks': 'changeViewEvent'
    'click @ui.innerNavLinks': 'changeViewEvent'
    'click @ui.addToLibraryButton': 'showAddToLibrary'
    'click @ui.removeFromLibraryButton': 'removeFromLibrary'

  behaviors:

    navigate_back: true

  initialize: (data) =>
    @breadcrumbs = data.breadcrumbs
    @breadcrumbsView = new BreadcrumbsView
      collection: new Backbone.Collection(@breadcrumbs)
    @model = data.exercise

    @listenTo(@model, 'sync', @onExerciseModelSync)

  templateHelpers: ->
    source: @model.get('source_item_id')
    authorId: @model.get('author').id
    public: @model.get('is_public')
    userId: App.request('current_user_id')

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
    navItem = $(ev.currentTarget).parent()
    if not $(navItem).hasClass 'active'
      @ui.innerNavItems.removeClass 'active'
      $(navItem).addClass 'active'
      navItemView = $(navItem).data 'view'
      @changeView navItemView

  changeView: (navView) =>
    console.log navView
    switch navView
      when 'overview'
        @overviewView = new ExerciseGlobalOverviewView model: @model
        @listenTo @overviewView, 'privacy:changed', @changePrivacyMarker
        @listenTo @overviewView, 'exercise:edit', @enableExerciseEditView
        @manageRegion.show @overviewView
      when 'video'
        view = new ExerciseGlobalAssignVideoView model: @model
        @manageRegion.show view
      when 'assign'
        @assignView = new ExerciseGlobalAssignView model: @model
        @manageRegion.show @assignView

  enableExerciseEditView: =>
    @exerciseEditView = new ExerciseEditView model: @model
    @listenToOnce @exerciseEditView, 'exercise:back', =>
      @changeView 'overview'
    @manageRegion.show @exerciseEditView

  showAddToLibrary: (ev) =>
    App.request 'base:addToLibraryModal', type: 'exercises', model: @model

  removeFromLibrary: (ev) =>
    copyId = $(ev.currentTarget).data('source')
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

  onExerciseModelSync: ->
    lastIndex = @breadcrumbs.length - 1
    @breadcrumbs[lastIndex].title = @model.get 'name'
    App.vent.trigger 'breadcrumbs:reload', @breadcrumbs
