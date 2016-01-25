define [
  'views/trainer/clients/client-group-nav-view'
  './template'
], (
  OldClientGroupNavView
  template
) ->
  class ClientGroupNavView extends OldClientGroupNavView

    template: template

    ui: _.extend OldClientGroupNavView::ui,
      tabHolders: '.gc-content-nav li'
      tab: '.gc-content-nav li span'

    events:
      'click @ui.deleteButton': '_deleteButtonClick'
      'click @ui.tab': '_tabClicked'

    _deleteButtonClick: (ev) ->
      @trigger('content-nav:delete')

    _tabClicked: (ev) ->
      @ui.tabHolders.removeClass('active')
      el = $(ev.currentTarget)
      el.parent().addClass('active')

      tabName = el.data('nav-view')
      @trigger('content-nav:tab', tabName)

