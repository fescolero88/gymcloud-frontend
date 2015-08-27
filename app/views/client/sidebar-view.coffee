Marionette = require 'backbone.marionette'

ClientExercises = require 'collections/client_exercises'
ClientWorkouts = require 'collections/client_workouts'
ClientPrograms = require 'collections/client_programs'

module.exports = class ClientSidebarView extends Marionette.LayoutView

  template: require('templates/sidebar/sidebar')

  className: 'gc-scrollable-area'

  ui:
    item: '.gc-sidebar-item > a'
    menu: '.toggle-menu'

  templateHelpers: ->
    data:
      exercises: -> App.request 'data:exercises'
      workouts: -> App.request 'data:workouts'
      programs: -> App.request 'data:programs'

  initialize: ->
    @exercisesCollection = new ClientExercises
    @workoutsCollection = new ClientWorkouts
    @programsCollection = new ClientPrograms

  onShow: =>
    @getSidebarItems()

  events:
    'click @ui.menu': 'toggleMenu'
    'click @ui.item': 'toggleItem'

  toggleMenu: (ev) ->
    if $(ev.target).hasClass('toggle-it') or $(ev.currentTarget).hasClass('toggle-it')
      ev.preventDefault()
      $(ev.currentTarget).toggleClass('active')

  toggleItem: (ev) ->
    activeItem = @el.querySelector '.gc-sidebar-item > a.active'
    if activeItem
      activeItem.classList.remove 'active'

    ev.currentTarget.classList.add 'active'

  getSidebarItems: =>
    $.when(
      @exercisesCollection.fetch(),
      @workoutsCollection.fetch(),
      @programsCollection.fetch()
    ).then =>
      App.request 'data:exercises:reset', @exercisesCollection.toJSON()
      App.request 'data:workouts:reset', @workoutsCollection.toJSON()
      App.request 'data:programs:reset', @programsCollection.toJSON()
      @render()
      window.App.vent.trigger 'assignments:loaded'
