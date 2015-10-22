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

    childViewContainer: '.stats-collection-container'

    className: 'gc-main-workspace row'

    behaviors:

      stickit:
        bindings:
          'h2 span':
            observe: 'user_profile.first_name'
            onGet: (value) ->
              if _.any(value)
                "Welcome, #{value}!"
              else
                "Welcome back!"

    constructor: ->
      @model = App.request('current_user')
      super
