Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

module.exports = class ClientGroupNavView extends Marionette.ItemView

  template: Templates.trainer.clients.client_group_nav

  events:
    'click @ui.navLink': 'navLinkClick'
    'click @ui.deleteButton': 'deleteButtonClick'
    'click .gc-content-nav-back a': 'navBack'

  ui:
    nav: '.gc-content-nav a'
    navLink: '.gc-content-nav :not(.gc-content-nav-back) a'
    deleteButton: '.gc-content-nav-delete'

  templateHelpers: =>
    client_id: @itemId
    view_name: @viewName

  initialize: (data) ->
    @itemId = data.itemId
    if data.viewType is 'clients'
      @viewName = 'clients'
    else
      @viewName = 'groups'
    @on 'changeActive', @changeActive

  navLinkClick: (ev) ->
    ev.preventDefault()
    href = $(ev.currentTarget).attr 'href'
    Backbone.history.navigate(href, { trigger:false, replace: true })

    @ui.nav.parent().removeClass('active')
    @$el.find(ev.currentTarget).parent().addClass('active')
    navView = @$el.find(ev.currentTarget).data('nav-view')
    @trigger 'navView', navView

  navigate: (navView) ->
    @ui.nav.parent().removeClass('active')
    @ui.nav.each (index, element) ->
      if $(element).data('nav-view') == navView
        $nav = $(element)
        $nav.parent().addClass('active')
    @trigger 'navView', navView

  navBack: (ev) ->
    window.history.back()

  deleteButtonClick: (ev) ->
    App.vent.trigger 'content-nav:delete'

  changeActive: (category) =>
    @ui.nav.parent().removeClass('active')
    @$el.find(".gc-content-nav a[data-nav-view = #{category}]").parent().addClass('active')
