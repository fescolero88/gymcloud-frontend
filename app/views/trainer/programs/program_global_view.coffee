Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ProgramGlobalOverviewView = require 'views/trainer/programs/program_global_overview_view'

module.exports = class ProgramGlobalView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global')

  regions:
    manageRegion: '#program-manage'

  ui:
    navBack: '.gc-content-nav-back'
    innerNav: '.gc-inner-nav'
    contentNavItems: '.gc-content-nav li'
    contentNavLinks: '.gc-content-nav li a'

  onShow: ->
    @changeView 'program'

  events:
    'click @ui.navBack': 'navigateBack'
    'click @ui.contentNavLinks': 'changeActiveTab'

  navigateBack: =>
    window.history.back()

  changeActiveTab: (ev) ->
    @changeViewEvent(ev, @ui.contentNavItems)

  changeViewEvent: (ev, ui) =>
    ev.preventDefault()
    navItem = $(ev.currentTarget).parent()
    if not $(navItem).hasClass 'active'
      ui.removeClass 'active'
      $(navItem).addClass 'active'
      navItemView = $(navItem).data 'view'

  changeView: (navView) =>
    switch navView
      when 'program'
        @overviewView = new ProgramGlobalOverviewView model: @model
        @manageRegion.show @overviewView