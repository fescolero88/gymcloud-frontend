define [
  './item/view'
  './empty/view'
  './template'
], (
  ItemView
  EmptyView
  template
) ->

  class AssignmentsListView extends Marionette.CompositeView

    className: 'gc-exercises-assign'

    template: template

    emptyView: EmptyView

    childView: ItemView

    childViewContainer: 'ul'

    childViewOptions: ->
      clientId: @clientId
      viewType: @viewType

    ui:
      rmAssign: '.gc-exercises-assign-btn-del'

    templateHelpers: =>
      viewType: _.humanize(@viewType)

    isEmpty: (collection) ->
      !collection.length

    initialize: (data) =>
      @clientId = @model.get('id')
      if @clientId is 0
        @myProfile = true
      @viewType = data.viewType
      @assignName = data.assignName
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
