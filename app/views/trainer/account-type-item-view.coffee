define [
  'templates/trainer/account-type-item'
], (
  template
) ->
  class AccountTypeItemView extends Marionette.ItemView

    tagName: 'li'

    className: 'gc-account-type-item'

    template: template

    events:
      'click': 'changeSelected'

    behaviors:

      stickit:
        bindings:
          '.gc-account-selected':
            observe: 'assigned'
            update: ($el, val, model, options) =>
              if model.get 'assigned'
                $el.addClass 'assigned'
              else
                $el.removeClass 'assigned'
          ':el':
            observe: 'selected'
            update: ($el, val, model, options) =>
              if model.get 'selected'
                $el.addClass 'active'
              else
                $el.removeClass 'active'

    changeSelected: ->
      @triggerMethod 'selected:changed'
      @model.set 'selected', true
