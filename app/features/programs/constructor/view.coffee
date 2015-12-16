define [
  './overview/view'
  'features/assignment_list/view'
  './template'
], (
  OverviewView
  AssignView
  template
) ->

  class ConstructorLayoutView extends Marionette.LayoutView

    behaviors:

      navigate_back: true

      breadcrumbs: true

      stickit:
        bindings:
          '[data-bind="name"]':
            observe: 'name'
            events: ['change']

    template: template

    regions:
      manageRegion: '#program-manage'
      actionsRegion: 'region[data-name="program-actions"]'

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
      isMine: @_isMine()
      canAddToLibrary: do =>
        !@_isMine() && !@_isAuthor() && @model.get('is_public')

    onShow: ->
      @_changeView('program')

    _isAuthor: =>
      @model.get('author_id') is App.request('current_user_id')

    _isMine: ->
      @model.get('user_id') == App.request('current_user_id')

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

      @[funcName](response)

    _onSyncUpdate: (_response) ->
      App.request('messenger:explain', 'program.updated')

    _onSyncError: (_response) ->
      App.request('messenger:explain', 'program.not_updated')

    _onDestroy: (response) ->
      url = "#program_templates_folder/#{response.folder_id}"
      Backbone.history.navigate(url, {trigger:true, replace: true})
      App.request('messenger:explain', 'program.deleted')
