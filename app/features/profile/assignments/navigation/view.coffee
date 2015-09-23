define [
  './template'
], (
  template
) ->
  class NavigationView extends Marionette.ItemView

    tagName: 'nav'

    className: 'gc-content-nav-wrapper row'

    template: template

    events:
      'click @ui.navLink': '_changeTab'
      'click @ui.deleteButton': 'deleteButtonClick'

    ui:
      activeTab: 'li.active'
      nav: '.gc-content-nav a'
      navLink: '.gc-content-nav :not(.gc-content-nav-back) a'
      deleteButton: '.gc-content-nav-delete'

    getActiveTabName: ->
      tab = @ui.activeTab
      tab.find('a').data('nav-view')

    navigate: (tabName) ->
      @ui.nav.parent().removeClass('active')
      link = @ui.navLink.filter("[data-nav-view=#{tabName}]")
      link.parent().addClass('active')
      @trigger('change:tab', tabName)

    deleteButtonClick: (ev) ->
      App.vent.trigger 'content-nav:delete'

    _changeTab: (ev) ->
      ev.preventDefault()
      link = ev.currentTarget
      tabName = $(link).data('nav-view')
      @navigate(tabName)