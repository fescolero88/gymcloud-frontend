define [
  './template'
  'moment'
], (
  template
  moment
) ->

  class PersonalBestItemView extends Marionette.LayoutView

    className: 'personal-best-item'

    template: template

    behaviors:

      stickit:
        bindings:
          '.title span': 'name'

    events:
      'click .delete': '_destroyResult'

    _destroyResult: ->
      App.request('modal:confirm:delete', @model)
