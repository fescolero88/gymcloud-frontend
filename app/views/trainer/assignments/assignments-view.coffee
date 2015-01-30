Marionette = require 'backbone.marionette'

module.exports = class AssignmentsView extends Marionette.ItemView
  template: Templates.trainer.assignments.assignments

  collectionEvents:
    "sync": "initSearchSelect"

  events:
    "click @ui.rmAssign": "rmAssign"

  ui:
    rmAssign: ".gc-exercises-assign-btn-del"

  templateHelpers: =>
    client_id: @clientId
    assign_name: @assignName
    view_type: @viewType

  initialize: (data) =>
    @clientId = data.clientId
    @assignName = data.assignName
    @viewType = data.viewType
    window.App.vent.on 'assignments:loaded', @initSearchSelect
    @on 'assign', (item) ->
      @assignItem item

  searchItems: (items, title) ->
    listItems = []
    for item in items
      if item.isFolder
        listItems = listItems.concat(@searchItems(item.items, item.title))
      else
        item.folder = title
        listItems.push item
    listItems

  rmAssign: (ev)=>
    ev.preventDefault()
    assignId = $(ev.currentTarget).data 'id'
    model = @collection.get assignId
    model.destroy().then =>
      @initSearchSelect()

  assignItem: (item)=>
    data =
      id: @clientId
      item_id: item.id
    $.ajax
      url: "/api/mobile/#{@viewType}/#{@clientId}/#{@assignName}"
      type: 'POST'
      dataType: 'json'
      data: JSON.stringify data
      success: (data) =>
        @collection.add data
        @initSearchSelect()

  initSearchSelect: =>
    @render()
    assignments = App.request "data:#{@assignName}"
    if assignments?
      options = @searchItems assignments, @assignName
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
          this_.assignItem {name: $item.text(), id: value}
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
