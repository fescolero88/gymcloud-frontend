define [
  './template'
  './item/view'
], (
  template
  StatsItemView
) ->

  class StatsCompositeView extends Marionette.CompositeView

    template: template

    childView: StatsItemView

    childViewContainer: 'ul'

    className: 'gc-main-workspace'

    behaviors:

      stickit:
        bindings:
          'h2 span':
            observe: 'user_profile.first_name'
            onGet: (value) ->
              if _.any(value)
                "Welcome, #{value}!"
              else
                'Welcome back!'

    constructor: ->
      @model = App.request('current_user')
      super
