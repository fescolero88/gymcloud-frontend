define [
  '../../breadcrumbs/view'
  './actions/view'
  './overview/view'
  './template'
], (
  Breadcrumbs
  ActionsView
  OverviewView
  template
) ->

  class ConstructorLayoutView extends Marionette.LayoutView

    className: 'gc-main-workspace row'

    template: template

    regions:
      manageRegion: '#program-manage'
      actionsRegion: 'region[data-name="program-actions"]'
      breadcrumbs: 'breadcrumbs'

    ui:
      navBack: '.gc-content-nav-back'
      innerNav: '.gc-inner-nav'
      contentNavItems: '.gc-program-content-navs li'
      contentNavLinks: '.gc-program-content-navs li a'

    modelEvents:
      destroy: 'programDeleted'

    events:
      'click @ui.navBack': 'navigateBack'
      'click @ui.contentNavLinks': 'changeActiveTab'

    templateHelpers: =>
      isAuthor: @_isAuthor()

    initialize: ->
      @breadcrumbs = new Breadcrumbs(model: @model)
      @actionsView = new ActionsView(model: @model) if @_isAuthor()

    onShow: ->
      @getRegion('breadcrumbs').show(@breadcrumbs)
      @getRegion('actionsRegion').show(@actionsView) if @_isAuthor()
      @changeView 'program'

    _isAuthor: =>
      @model.get('author_id') is App.request('current_user_id')

    navigateBack: ->
      window.history.back()

    changeActiveTab: (ev) ->
      @_changeViewEvent(ev, @ui.contentNavItems)

    _changeViewEvent: (ev, ui) ->
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      if not $(navItem).hasClass('active')
        ui.removeClass('active')
        $(navItem).addClass('active')
        navItemView = $(navItem).data('view')

    changeView: (navView) =>
      switch navView
        when 'program'
          view = new OverviewView(model: @model)
          @manageRegion.show(view)

    programDeleted: ->
      id = @model.get 'id'
      name = @model.get 'name'
      App.request 'data:delete', 'programs', id

      rootId = App.request "data:programs:root"
      folderId = @model.get('folder_id')
      @model.set 'key', @model.get('id')
      if folderId and folderId isnt 0 and folderId isnt rootId
        App.vent.trigger "programs:folder:#{folderId}:model:removed", @model
      else
        App.vent.trigger "programs:model:removed", @model

      window.history.back()
      App.request 'messenger:show',
        hideAfter: 5
        message: "Program #{name} deleted."
        type: 'info'
