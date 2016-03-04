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
      behavior = @
      items = @_prepareItems()
      $select = @ui.autocomplete.selectize
        hideSelected: @options.hideSelected
        valueField: @options.valueField
        labelField: @options.labelField
        sortField: @options.sortField
        searchField: @options.searchField
        options: items
        onItemAdd: (value, $item) ->
          func = behavior.options.onItemAdd
          _.bind(func, behavior.view, value, $item, @)()
          return
        render: @options.render
        dropdownParent: 'body'
      @control = $select[0].selectize

    _prepareItems: ->
      collection = _.result @options, 'collection'
      if collection instanceof Backbone.Collection
        @collection = collection
        @listenTo(collection, 'reset add remove', @_updateOptionItems)
        collection.map(@options.serealizeFn)
      else
        collection

    _updateOptionItems: ->
      return unless @control
      items = @collection.map(@options.serealizeFn)
      @control.clearOptions()
      @control.addOption(items)
      @control.refreshOptions(false)

