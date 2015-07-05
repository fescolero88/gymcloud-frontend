Marionette = require 'backbone.marionette'

module.exports = class ClientSidebarView extends Marionette.LayoutView

  template: require('templates/client/sidebar')

  className: 'gc-scrollable-area'

  ui:
    item: '.gc-sidebar-item > a'
    menu: '.toggle-menu'

  initialize: ->
    App.vent.on 'profile:ready', =>
      @getData()

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

  templateHelpers: =>
    exercises: => App.request 'data:exercises'
    workouts: => App.request 'data:workouts'
    programs: => App.request 'data:programs'

  getData: =>
    console.log App.request 'data:exercises'
    if !App.request 'data:exercises'
      $.ajax
        url: '/api/mobile/library/'
        type: 'GET'
        dataType: 'json'
        success: (data) =>
          for item in data
            console.log data
            switch item.title
              when 'Exercises'
                App.request 'data:exercises:reset', item.items
                App.request 'data:exercises:root:reset', item.key
              when 'Workouts'
                App.request 'data:workouts:reset', item.items
                App.request 'data:workouts:root:reset', item.key
              when 'Programs'
                App.request 'data:programs:reset', item.items
                App.request 'data:programs:root:reset', item.key
          window.App.vent.trigger 'assignments:loaded'
          @render()