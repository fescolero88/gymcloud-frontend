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
    @exerciseModel = data.exercise

  templateHelpers: ->
    source: @exerciseModel.get('source_item_id')
    author: @exerciseModel.get('user_id')
    public: @exerciseModel.get('is_public')
    inLibrary: @exerciseModel.get('is_in_my_library')

  onShow: =>
    @overviewView = new ExerciseGlobalOverviewView model: @exerciseModel
    @manageRegion.show @overviewView
    @breadcrumbsRegion.show @breadcrumbsView

  goBack: (ev) ->
    ev.preventDefault()
    window.history.back()