define [
  './overview/view'
  'features/breadcrumbs/view'
  'features/video_assignment/view'
  './template'
], (
  OverviewView
  Breadcrumbs
  VideoAssignmentView
  template
) ->
  class ExerciseConstructorView extends Marionette.LayoutView

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
      sync: '_onSync'
      error: '_onSyncError'
      'change:is_public': '_changePrivacyMarker'
      'change:video_url': '_videoAssigned'

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
      navItemView = $(navItem).data('view')
      @_changeView(navItemView)

    _changeView: (name) ->
      navItem = @ui.innerNavItems.filter("[data-view='#{name}']")

      unless navItem.hasClass('active')
        @ui.innerNavItems.removeClass('active')
        navItem.addClass('active')
        @_renderView(name)

    _renderView: (navView) ->
      View = {
        overview: OverviewView
        video: VideoAssignmentView
      }[navView] || OverviewView
      view = new View(model: @model)
      @getRegion('manage').show(view)

    showAddToLibrary: (ev) ->
      ev.preventDefault()
      App.request 'base:addToLibraryModal', type: 'exercises', model: @model

    _removeFromLibrary: (ev) ->
      ev.preventDefault()
      App.request 'base:confirmationalModal',
        title: 'Remove exercise?'
        content: 'Are you sure you want to remove this exercise from library?'
        confirmBtn: 'Remove'
        confirmCallBack: => @model.destroy(wait: true)

    _onSync: (_model, response, options) ->
      funcName = {PATCH: '_onSyncUpdate'}[options.type] || '_onDestroy'
      this[funcName](response)

    _onSyncUpdate: (_response) ->
      App.request 'messenger:show',
        hideAfter: 5
        message: 'Exercise Updated.'
        type: 'success'

    _onSyncError: (_response) ->
      App.request('messenger:show', message: 'Oops. Something went wrong')

    _onDestroy: (response) ->
      url = "#exercises_folder/#{response.folder_id}"
      Backbone.history.navigate(url, {trigger:true, replace: true})
      App.request('messenger:show', message: 'Exercise removed from library')

    _changePrivacyMarker: ->
      if @model.get('is_public')
        @ui.privateMarker.addClass('hide')
        @ui.publicMarker.removeClass('hide')
      else
        @ui.publicMarker.addClass('hide')
        @ui.privateMarker.removeClass('hide')

    _videoAssigned: ->
      @_changeView('overview')

    _isAuthor: ->
      @model.get('author_id') == App.request('current_user_id')