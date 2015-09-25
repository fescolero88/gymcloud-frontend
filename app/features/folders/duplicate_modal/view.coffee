define [
  './item/view'
  './template'
], (
  ItemView
  template
) ->

  class DuplicateGlobalEWPModalView extends Marionette.CompositeView

    template: template

    className: 'modal-dialog modal-md'

    childView: ItemView

    childViewContainer: 'ul'

    ui:
      itemsList: '.gc-duplicate-folders-list'

    events:
      'submit @ui.form': 'submitForm'

    initialize: (data) ->
      @typeName = data.type

    templateHelpers: ->
      type: @typeName
      typeSinglular: _.chain(@typeName).singularize().humanize().value()

    submitForm: (ev) ->
      ev.preventDefault()
      checked = @ui.itemsList.find(':checked')
      ids = checked.map((_index, el) -> $(el).data('id'))
      @trigger("items:duplicate", ids)