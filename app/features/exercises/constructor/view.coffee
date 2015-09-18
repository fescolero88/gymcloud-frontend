define [
  './overview/view'
  '../../breadcrumbs/view'
  './template'
], (
  OverviewView
  Breadcrumbs
  template
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
      innerNavItems: '.gc-content-nav li'
      innerNavLinks: '.gc-content-nav li a'
      addToLibraryButton: '.gc-add-to-library-button'
      removeFromLibraryButton: '.gc-exercise-delete-button'

    events:
      'click @ui.innerNavLinks': 'changeViewEvent'
      'click @ui.innerNavLinks': 'changeViewEvent'
      'click @ui.addToLibraryButton': 'showAddToLibrary'
      'click @ui.removeFromLibraryButton': 'removeFromLibrary'

    behaviors:

      navigate_back: true

    modelEvents:
      'change:is_public': '_changePrivacyMarker'

    templateHelpers: =>
      isAuthor: @_isAuthor()

    initialize: (data) ->
      @breadcrumbs = new Breadcrumbs(model: @model)
      @overview = new OverviewView(model: @model)

    onRender: ->
      @getRegion('manage').show(@overview)
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
          @getRegion('manage').show(@overview)
        else
          App.request 'messenger:show',
            message: 'Not emplemented yet'

    showAddToLibrary: (ev) ->
      ev.preventDefault()
      App.request 'base:addToLibraryModal', type: 'exercises', model: @model

    removeFromLibrary: (ev) ->
      ev.preventDefault()
      id = @model.get('id')
      App.request 'base:confirmationalModal',
        title: "Remove exercise?"
        content: "Are you sure you want to remove this exercise from exercise?"
        confirmBtn: "Remove"
        confirmCallBack: _.bind(@_removeFromLibraryCallback, this, id)

    _removeFromLibraryCallback: (id) ->
      $.ajax
        method: 'DELETE'
        url: "/api/mobile/exercises/#{id}"
        dataType: 'json'
        success: (model) ->
          App.request 'messenger:show',
            message: 'Exercise removed from library'
        error: ->
          App.request 'messenger:show',
            message: 'Not emplemented on api side'

    _changePrivacyMarker: ->
      if @model.get('is_public')
        @ui.privateMarker.addClass('hide')
        @ui.publicMarker.removeClass('hide')
      else
        @ui.publicMarker.addClass('hide')
        @ui.privateMarker.removeClass('hide')

    _isAuthor: ->
      @model.get('author').id == App.request('current_user_id')