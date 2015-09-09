define [
  'backbone.marionette'
  './actions/view'
  './overview/view'
  './template'
], (
  Marionette
  ActionsView
  OverviewView
  template
) ->

  class ConstructorLayoutView extends Marionette.LayoutView

    className: 'gc-main-workspace row'

    template: template

    regions:
      manageRegion: '#program-manage'
      programActionsRegion: 'region[data-name="program-actions"]'

    ui:
      navBack: '.gc-content-nav-back'
      innerNav: '.gc-inner-nav'
      contentNavItems: '.gc-program-content-navs li'
      contentNavLinks: '.gc-program-content-navs li a'
      programName: '.gc-program-name'

    modelEvents:
      destroy: 'programDeleted'

    events:
      'click @ui.navBack': 'navigateBack'
      'click @ui.contentNavLinks': 'changeActiveTab'
      'blur @ui.programName': 'saveName'
      'keypress @ui.programName': 'updateName'

    bindings:
      '[data-bind="name"]':
        observe: 'name'
        events: ['change']

    templateHelpers: =>
      isAuthor: @_isAuthor()

    onShow: ->
      @stickit()
      if @_isAuthor()
        programActionsView = new ActionsView(model: @model)
        @getRegion('programActionsRegion').show(programActionsView)
        'add:note'

      @changeView 'program'

    onDestroy: ->
      @unstickit()

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

    saveName: ->
      @model.save() if @model.hasChanged('name')

    updateName: (e) ->
      if e.which is 13
        e.preventDefault()
        @ui.programName.blur()

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
