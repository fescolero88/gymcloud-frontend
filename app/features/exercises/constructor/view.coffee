define [
  './overview/view'
  '../../breadcrumbs/view'
  './template'
  'views/trainer/exercises/exercise_global_assign_video_view'
], (
  OverviewView
  Breadcrumbs
  template
  ExerciseGlobalAssignVideoView
) ->
  class ExerciseGlobalView extends Marionette.LayoutView

    template: template

    regions:
      manage: 'region[data-name="exercise-manage"]'
      breadcrumbs: 'region[data-name="breadcrumbs"]'

    ui:
      title: '.gc-breadcrumbs-title'
      publicMarker: '.gc-privacy-public'
      privateMarker: '.gc-privacy-private'
      innerNavItems: '.gc-exercise-nav li'
      innerNavLinks: '.gc-exercise-nav li a'
      addToLibraryButton: '.gc-add-to-library-button'
      removeFromLibraryButton: '.gc-exercise-delete-button'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'
      'click @ui.addToLibraryButton': 'showAddToLibrary'
      'click @ui.removeFromLibraryButton': '_removeFromLibrary'

    behaviors:

      navigate_back: true

    modelEvents:
      'change:is_public': '_changePrivacyMarker'

    templateHelpers: =>
      isAuthor: @_isAuthor()

    initialize: (data) ->
      @breadcrumbs = new Breadcrumbs(model: @model)

    onRender: ->
      view = new OverviewView(model: @model)
      @getRegion('manage').show(view)
      @getRegion('breadcrumbs').show(@breadcrumbs)

    changeViewEvent: (ev) ->
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      unless $(navItem).hasClass 'active'
        @ui.innerNavItems.removeClass 'active'
        $(navItem).addClass 'active'
        navItemView = $(navItem).data 'view'
        @changeView navItemView

    changeView: (navView) ->
      switch navView
        when 'overview'
          view = new OverviewView(model: @model)
          @getRegion('manage').show(view)
        when 'video'
          view = new ExerciseGlobalAssignVideoView(model: @model)
          @getRegion('manage').show(view)
        when 'assign'
          App.request 'messenger:show',
            message: 'Not yet implemented.'

    showAddToLibrary: (ev) ->
      ev.preventDefault()
      App.request 'base:addToLibraryModal', type: 'exercises', model: @model

    _removeFromLibrary: (ev) ->
      ev.preventDefault()
      App.request 'base:confirmationalModal',
        title: "Remove exercise?"
        content: "Are you sure you want to remove this exercise from exercise?"
        confirmBtn: "Remove"
        confirmCallBack: _.bind(@_removeFromLibraryCallback, this)

    _removeFromLibraryCallback: (id) ->
      @model.destroy(wait: true)
        .then (response) ->
          url = "#exercises_folder/#{response.folder_id}"
          Backbone.history.navigate(url, {trigger:true, replace: true})
          App.request 'messenger:show',
            message: 'Exercise removed from library'
        .fail ->
          App.request 'messenger:show',
            message: 'Oops. Something went wrong'

    _changePrivacyMarker: ->
      if @model.get('is_public')
        @ui.privateMarker.addClass('hide')
        @ui.publicMarker.removeClass('hide')
      else
        @ui.publicMarker.addClass('hide')
        @ui.privateMarker.removeClass('hide')

    _isAuthor: ->
      @model.get('author').id == App.request('current_user_id')