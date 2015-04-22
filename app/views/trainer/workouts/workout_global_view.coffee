Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

WorkoutGlobalOverviewView = require 'views/trainer/workouts/workout_global_overview_view'

BreadcrumbsView = require 'views/general/breadcrumbs/breadcrumbs-view'
BreadcrumbsCollection = require 'models/general/breadcrumbs'

module.exports = class WorkoutGlobalView extends Marionette.LayoutView

  template: Templates.trainer.workouts.workout_global

  regions:
    manageRegion: '#exercise-manage'
    breadcrumbsRegion: '#breadcrumbs'

  ui:
    title: '.gc-breadcrumbs-title'
    innerNavItems: '.gc-content-nav li'
    innerNavLinks: '.gc-content-nav li a'

  events:
    'click @ui.innerNavLinks': 'changeViewEvent'

  initialize: (data) =>
    @breadcrumbsView = new BreadcrumbsView(collection: new BreadcrumbsCollection(data.breadcrumbs))
    @workoutModel = data.workout

  onShow: =>
    @changeView 'overview'
    @breadcrumbsRegion.show @breadcrumbsView

  changeViewEvent: (ev) =>
    ev.preventDefault()
    navItem = $(ev.currentTarget).parent()
    if not $(navItem).hasClass 'active'
      @ui.innerNavItems.removeClass 'active'
      $(navItem).addClass 'active'
      navItemView = $(navItem).data 'view'
      @changeView navItemView

  changeView: (navView) =>
    switch navView
      when 'overview'
        @overviewView = new WorkoutGlobalOverviewView model: @workoutModel
        @manageRegion.show @overviewView
