Marionette = require 'backbone.marionette'

class EmptyView extends Marionette.ItemView

  template: Templates.trainer.assignments.assignment_empty

class AssignmentItemView extends Marionette.ItemView

  template: Templates.trainer.assignments.assignment_item

  tagName: 'li'

  className: 'row'

  initialize: (data) ->
    @viewType = data.viewType
    @clientId = data.clientId
    @assignName = data.assignName

  templateHelpers: ->
    client_id: @clientId
    assign_name: @assignName
    view_type: @viewType

module.exports = class AssignmentsListView extends Marionette.CompositeView

  template: Templates.trainer.assignments.assignments

  childView: AssignmentItemView

  childViewContainer: 'ul'

  emptyView: EmptyView

  childViewOptions: ->
    clientId: @clientId
    assignName: @assignName
    viewType: @viewType

  events:
    'click @ui.rmAssign': 'rmAssign'

  ui:
    rmAssign: '.gc-exercises-assign-btn-del'

  isEmpty: (collection) ->
    !collection.length

  initialize: (data) =>
    @clientId = parseInt(data.clientId)
    if @clientId is 0
      @myProfile = true
    @assignName = data.assignName
    @viewType = data.viewType
    @on 'assign', (item) ->
      @assignItem item

  onShow: ->
    @initSearchSelect()

  searchItems: (items, title) ->
    listItems = []
    for item in items
      if item.isFolder
        listItems = listItems.concat(@searchItems(item.items, item.title))
      else
        item.folder = title
        listItems.push item
    listItems

  rmAssign: (ev) =>
    ev.preventDefault()
    App.request 'base:confirmationalModal',
      title: "Delete item(s)"
      content: "Are you sure you want to delete selected items?"
      confirmBtn: "Delete"
      confirmCallBack: =>
        assignId = $(ev.currentTarget).data 'id'
        model = @collection.get assignId
        model.destroy().then =>
          if !@collection.length
            @collection.isFetched = false
          App.request 'messenger:show',
            message: 'Exercise was deleted from the list'
            type: 'error'

  assignItem: (item) =>
    data =
      id: @clientId
      item_id: item.id
    if @myProfile
      url = "/api/mobile/me/#{@assignName}"
    else
      url = "/api/mobile/#{@viewType}/#{@clientId}/#{@assignName}"
    $.ajax
      url: url
      type: 'POST'
      dataType: 'json'
      data: JSON.stringify data
      success: (data) =>
        @collection.add data
        @trigger 'activityRefresh'
        App.request 'messenger:show',
          message: "#{data.name} was assigned"
          type: 'success'

  initSearchSelect: =>
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
