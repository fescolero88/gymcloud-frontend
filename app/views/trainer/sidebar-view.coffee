Marionette = require 'backbone.marionette'

module.exports = class SideBarView extends Marionette.ItemView
  template: Templates.trainer.sidebar.sidebar

  events:
    "click .toggle-menu": "toggleMenu"

  initialize: =>
    @exercises = []
    @workouts = []
    @programs = []
    @clients = []
    @groups = []

    @getData()

  templateHelpers: =>
    exercises: => @exercises
    workouts: => @workouts
    programs: => @programs

  toggleMenu: (ev) ->
    if not $(ev.target).hasClass 'gc-sidebar-cat-name'
      ev.preventDefault()
      $(ev.currentTarget).toggleClass('active')

  getData: =>
    $.ajax
      url: '/api/mobile/library/'
      type: 'GET'
      dataType: 'json'
      success: (data) =>
        for item in data
          switch item.title
            when "Exercises" then @exercises = item.items
            when "Workouts" then @workouts = item.items
            when "Programs" then @programs = item.items
        @render()
