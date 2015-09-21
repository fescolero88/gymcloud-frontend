define [
  './item_template'
  './option_template'
], (
  itemTemplate
  optionTemplate
) ->

  class AutoCompleteBehaviour extends Marionette.Behavior
    
    ui:
      'autocomplete': '.gc-auto-complete'

    defaults:
      hideSelected: true
      valueField: 'id'
      labelField: 'name'
      searchField: ['name']
      collection: undefined
      onItemAdd: undefined
      render:
        item: (item, escape) ->
          item.name = escape(item.name)
          itemTemplate(item)
        option: (item, escape) ->
          _item =
            folder_name: escape(item.folder?.name || "workouts")
            name: escape(item.name)
          optionTemplate(_item)

    onShow: ->
      items = _.result @options, 'collection'
      @ui.autocomplete.selectize
        hideSelected: @options.hideSelected
        valueField: @options.valueField
        labelField: @options.labelField
        searchField: @options.searchField
        options: items
        onItemAdd: @options.onItemAdd
        render: @options.render

