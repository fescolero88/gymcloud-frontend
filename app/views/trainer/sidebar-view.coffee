Marionette = require 'backbone.marionette'

module.exports = class SideBarView extends Marionette.ItemView
  exercises: []
  workouts: []
  programs: []
  clients: []
  groups: []

  template: require '../../templates/trainer/sidebar/sidebar'

  events:
    "click .toggle-menu": "toggle_menu"

  initialize: =>
    @get_data()

  templateHelpers: =>
    exercises: => @exercises
    workouts: => @workouts
    programs: => @programs

  toggle_menu: (ev) ->
    if not $(ev.target).hasClass 'gc-sidebar-cat-name'
      ev.preventDefault()
      $(ev.currentTarget).toggleClass('active')

  get_data: =>
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
