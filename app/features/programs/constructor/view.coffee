define [
  '../../breadcrumbs/view'
  './actions/view'
  './overview/view'
  'features/assignment_list/view'
  './template'
], (
  Breadcrumbs
  ActionsView
  OverviewView
  AssignView
  template
) ->

  class ConstructorLayoutView extends Marionette.LayoutView

    behaviors:

      navigate_back: true

      stickit:
        bindings:
          '[data-bind="name"]':
            observe: 'name'
            events: ['change']


    template: template

    regions:
      manageRegion: '#program-manage'
      actionsRegion: 'region[data-name="program-actions"]'
      breadcrumbs: 'region[data-name="breadcrumbs"]'

    ui:
      innerNav: '.gc-inner-nav'
      contentNavItems: '.gc-program-content-navs li'
      contentNavLinks: '.gc-program-content-navs li a'

    modelEvents:
      destroy: 'programDeleted'

    events:
      'click @ui.contentNavLinks': '_changeViewEvent'

    templateHelpers: =>
      isAuthor: @_isAuthor()

    initialize: ->
      @breadcrumbs = new Breadcrumbs(model: @model)
      @actionsView = new ActionsView(model: @model) if @_isAuthor()

    onShow: ->
      @getRegion('breadcrumbs').show(@breadcrumbs)
      @getRegion('actionsRegion').show(@actionsView) if @_isAuthor()
      @_changeView('program')

    _isAuthor: =>
      @model.get('author_id') is App.request('current_user_id')

    _changeViewEvent: (ev, ui) ->
      ui = @ui.contentNavItems
      ev.preventDefault()
      navItem = $(ev.currentTarget).parent()
      if not $(navItem).hasClass('active')
        ui.removeClass('active')
        $(navItem).addClass('active')
        navItemView = $(navItem).data('view')
        @_changeView(navItemView)

    _changeView: (navView) =>
      View = {
        program: OverviewView
        assign: AssignView
      }[navView]

      view = new View(model: @model, entityType: 'program')
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
