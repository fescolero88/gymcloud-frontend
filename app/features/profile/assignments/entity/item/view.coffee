define [
  './template'
], (
  template
) ->

  class AssignmentItemView extends Marionette.ItemView

    template: template

    tagName: 'li'

    className: 'row'

    events:
      'click .gc-exercises-assign-btn-del': '_destroyModel'

    initialize: (data) ->
      @viewType = data.viewType

    templateHelpers: =>
      assign_name: @viewType.split('_')[1]
      viewType: @viewType

    _destroyModel: (ev) ->
      App.request 'modal:confirm',
        title: 'Delete item'
        content: 'Are you sure you want to delete selected item?'
        confirmBtn: 'Delete'
        confirmCallBack: _.bind(@_confirmCallBack, @)

    _confirmCallBack: ->
      @model.destroy(wait: true).then ->
        App.request 'messenger:show',
          message: "#{_.humanize(@viewType)} was deleted from the list"
          type: 'error'
