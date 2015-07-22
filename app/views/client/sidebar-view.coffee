Marionette = require 'backbone.marionette'

SidebarItemsCollection = require 'models/client/client_sidebar_model'

module.exports = class ClientSidebarView extends Marionette.LayoutView

  template: require('templates/client/sidebar')

  className: 'gc-scrollable-area'

  ui:
    item: '.gc-sidebar-item > a'
    menu: '.toggle-menu'

  initialize: ->
    @exercises = []
    @workouts = []
    @programs = []
    App.vent.on 'profile:ready', @onProfile

  onDestroy: ->
    App.vent.off 'profile:ready', @onProfile

  onProfile: =>
    @getData()
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

  getData: =>
    if !App.request 'data:exercises'
      $.ajax
        url: '/api/mobile/library/'
        type: 'GET'
        dataType: 'json'
        success: (data) =>
          for item in data
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
          console.log App.request 'data:exercises'

  getSidebarItems: =>
    profileModel = App.request 'data:profile'
    console.log profileModel
    clientId = profileModel.get 'id'
    exercisesCollection = new SidebarItemsCollection()
    exercisesCollection.url = "#{exercisesCollection.url}/#{clientId}/programs"
    exercisesCollection.fetch( id: clientId )