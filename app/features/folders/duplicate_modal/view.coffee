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
      folderInput: '.gc-folders-input'
      form: '.gc-duplicate-form'
      itemsList: '.gc-duplicate-folders-list'

    events:
      'submit @ui.form': 'submitForm'

    initialize: (data) =>
      @items = data.items
      @typeName = data.type

    templateHelpers: ->
      type: @typeName
      typeSinglular: _.chain(@typeName).singularize().humanize().value()

    submitForm: (ev) =>
      ev.preventDefault()
      ids = []
      for ch in @ui.itemsList.find(':checked')
        ids.push $(ch).data 'id'
      @trigger "items:duplicate", ids