Marionette = require 'backbone.marionette'

module.exports = class ClientPageView extends Marionette.LayoutView

  template: Templates.client.clientpage

  regions:
    nav: '#clientpage-nav-region'
    content: '#clientpage-content-region'

  initialize: =>
    App.vent.on 'profile:ready', =>
      @getData()

  onShow: =>
    @getData()

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
