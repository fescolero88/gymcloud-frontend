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
      sync: '_onSync'
      error: '_onSyncError'

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
      }[navView] || OverviewView

      view = new View(model: @model, entityType: 'program')
      @manageRegion.show(view)

    _onSync: (_model, response, options) ->
      funcName = {PATCH: '_onSyncUpdate'}[options.type] || '_onDestroy'

      this[funcName](response)

    _onSyncUpdate: (_response) ->
      App.request 'messenger:show',
        message: "Program Updated."
        type: 'success'

    _onSyncError: (_response) ->
      App.request('messenger:show', message: 'Oops. Something went wrong')

    _onDestroy: (response) ->
      url = "#program_templates_folder/#{response.folder_id}"
      Backbone.history.navigate(url, {trigger:true, replace: true})
      App.request('messenger:show', message: 'Program removed from library')
