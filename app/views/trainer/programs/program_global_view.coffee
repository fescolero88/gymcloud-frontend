Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ProgramGlobalActionsView = require 'views/trainer/programs/program_global_actions_view'
ProgramGlobalOverviewView = require 'views/trainer/programs/program_global_overview_view'

module.exports = class ProgramGlobalView extends Marionette.LayoutView

  template: require('templates/trainer/programs/program_global')

  regions:
    manageRegion: '#program-manage'
    programActionsRegion: 'region[data-name="program-actions"]'

  ui:
    navBack: '.gc-content-nav-back'
    innerNav: '.gc-inner-nav'
    contentNavItems: '.gc-content-nav li'
    contentNavLinks: '.gc-content-nav li a'
    programName: '.gc-program-name'

  modelEvents:
    destroy: 'programDeleted'

  onShow: ->
    programActionsView = new ProgramGlobalActionsView model: @model
    @getRegion('programActionsRegion').show programActionsView
    @changeView 'program'

  events:
    'click @ui.navBack': 'navigateBack'
    'click @ui.contentNavLinks': 'changeActiveTab'
    'blur @ui.programName': 'updateTitleOnBlur'
    'keypress @ui.programName': 'updateName'

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

  updateTitleOnBlur: (e) ->
    App.commands.execute 'program:title:update', @ui.programName.text()

  updateName: (e) ->
    if e.which is 13
      e.preventDefault()
      @ui.programName.blur()

  programDeleted: ->
    id = @model.get 'id'
    name = @model.get 'name'
    App.request 'data:delete', 'programs', id

    rootId = App.request "data:programs:root"
    folderId = @model.get 'folder_id'
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