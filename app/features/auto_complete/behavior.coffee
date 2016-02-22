define [
  './item_template'
  './option_template'
], (
  itemTemplate
  optionTemplate
) ->

  class AutoCompleteBehavior extends Marionette.Behavior

    key: 'auto_complete'

    ui:
      'autocomplete': '.gc-auto-complete'

    defaults:
      hideSelected: true
      valueField: 'id'
      labelField: 'name'
      sortField: 'sort_id'
      searchField: ['name']
      collection: undefined
      onItemAdd: undefined
      onLoad: undefined
      render:
        item: (item, escape) ->
          itemTemplate(item)
        option: (item, escape) ->
          optionTemplate(item)

    onShow: ->
      items = _.result @options, 'collection'
      @ui.autocomplete.selectize
        hideSelected: @options.hideSelected
        valueField: @options.valueField
        labelField: @options.labelField
        sortField: @options.sortField
        searchField: @options.searchField
        options: items
        onItemAdd: @options.onItemAdd
        render: @options.render
        dropdownParent: 'body'
