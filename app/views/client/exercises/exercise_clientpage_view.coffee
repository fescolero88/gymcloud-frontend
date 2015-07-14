Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ExerciseGlobalOverviewView = require 'views/client/exercises/exercise_clientpage_overview_view'

BreadcrumbsView = require 'views/general/breadcrumbs/breadcrumbs-view'
BreadcrumbsCollection = require 'models/general/breadcrumbs'

module.exports = class ExerciseGlobalView extends Marionette.LayoutView

  template: require('templates/client/exercises/exercise_clientpage')

  regions:
    manageRegion: '#exercise-manage'
    breadcrumbsRegion: '#breadcrumbs'

  ui:
    backButton: '.gc-content-nav-back'

  events:
    'click @ui.backButton': 'goBack'

  initialize: (data) =>
    @breadcrumbs = data.breadcrumbs
    @breadcrumbsView = new BreadcrumbsView(collection: new BreadcrumbsCollection(@breadcrumbs))

  onShow: =>
    overviewView = new ExerciseGlobalOverviewView model: @model
    @manageRegion.show overviewView
    @breadcrumbsRegion.show @breadcrumbsView

  goBack: (ev) ->
    ev.preventDefault()
    window.history.back()