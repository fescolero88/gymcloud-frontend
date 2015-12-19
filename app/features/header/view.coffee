define [
  './template'
], (
  template
) ->

  class HeaderView extends Marionette.LayoutView

    template: template

    className: 'gc-topbar'

    regions:
      searchBar: 'region[data-name="search-bar"]'

    behaviors:
      stickit:
        bindings:
          '.is_pro':
            observe: 'is_pro'
            visible: true
          '.gc-topbar-avatar a':
            classes:
              'presents':
                observe: 'user_profile.avatar.thumb.url'
            attributes: [
                name: 'title'
                observe: [
                  'user_profile.first_name'
                  'user_profile.last_name'
                ]
                onGet: (values) ->
                  _.compact(values).join(' ')
            ]
          '.gc-topbar-avatar img':
            attributes: [
                name: 'src'
                observe: 'user_profile.avatar.thumb.url'
            ]

    initialize: ->
      @listenTo(App.vent, 'profile:ready', @render)
      @model = App.request('current_user')

    onBeforeRender: ->
      @model.set(App.request('current_user').attributes)

    onRender: ->
      @$('img').on('error', @_onImgError)
      App.vent.trigger('app:view:header:render', @)

    onDestroy: ->
      App.vent.trigger('app:view:header:destroy', @)

    _onImgError: =>
      @model.set('user_profile.avatar.url', undefined)
