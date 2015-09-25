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
      typeSingle: @typeName.substring(0, @typeName.length - 1)

    onShow: =>
      @collection = new Backbone.Collection(@searchItems @items, @typeName)
      @render()

    searchItems: (items, category) =>
      result = []
      $.each items, (index, item) =>
        if item.isFolder
          result.push
            key: item.key
            title: item.title
            label: category
          category = item.title
          result = result.concat @searchItems(item.items, category)
      return result

    submitForm: (ev) =>
      ev.preventDefault()
      ids = []
      for ch in @ui.itemsList.find(':checked')
        ids.push $(ch).data 'id'
      @trigger "items:duplicate", ids