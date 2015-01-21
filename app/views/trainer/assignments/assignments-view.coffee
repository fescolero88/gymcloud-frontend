Marionette = require 'backbone.marionette'

module.exports = class AssignmentsView extends Marionette.ItemView
  template: Templates.trainer.assignments.assignments

  collectionEvents:
    "sync": "initSearchSelect"

  templateHelpers: =>
    client_id: @clientId
    assign_name: @assignName

  initialize: (data) =>
    @clientId = data.clientId
    @assignName = data.assignName
    window.App.vent.on 'assignments:loaded', @initSearchSelect
    @on 'assign', (item) ->
      @collection.add item
      @render()

  searchItems: (items, title) ->
    listItems = []
    for item in items
      if item.isFolder
        listItems = listItems.concat(@searchItems(item.items, item.title))
      else
        item.folder = title
        listItems.push item
    listItems

  initSearchSelect: =>
    @render()
    if window.App[@assignName]?
      options = @searchItems window.App[@assignName], @assignName
      this_ = @
      @$el.find('.live-search').selectize
        #openOnFocus: false
        hideSelected: true
        valueField: 'key'
        labelField: 'title'
        searchField: ['title']
        options: options
        onItemAdd: (value, $item) ->
          @clear()
          this_.collection.add {name: $item.text(), id: value}
          this_.initSearchSelect()
        render:
          item: (item, escape) ->
              return '<div>' +
                  (item.title ? '<span>' + escape(item.title) + '</span>' : '') +
                  (item.title ? '<span>' + escape(item.title) + '</span>' : '') +
              '</div>'
          option: (item, escape) ->
              label = item.folder || item.title
              caption = (if item.folder then item.title else null)
              return '<div>' +
                  '<span class="label">' + escape(label) + '</span>' +
                  (caption ? '<span class="caption">' + escape(caption) + '</span>' : '') +
              '</div>'
