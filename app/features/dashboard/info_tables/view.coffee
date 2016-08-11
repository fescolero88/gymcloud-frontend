define [
  './template'
  './../workout_events/model'
  'features/dashboard/client_performance/view'
], (
  template
  DataModel
  ClientPerformanceCollectionView
) ->

  class InfoTablesView extends Marionette.LayoutView

    template: template

    behaviors: ->
      getBindingFor = (name) ->
        ".content > [data-name='#{name}']":
          observe: 'tab'
          visible: (value) ->
            value is name
        "[tab-name='#{name}']":
          classes:
            active:
              observe: 'tab'
              onGet: (value) ->
                value is name

      stickit:
        bindings: _.reduce(@options.tables, (obj, table) ->
          obj[table.region] = getBindingFor(table.region)
          obj
        , {})

      regioned:
        views: @options.tables

    events:
      'click .tab-link': '_onChangeTab'

    templateHelpers: ->
      tables: @options.tables

    initialize: ->
      @model = new DataModel

    _onChangeTab: (ev) ->
      tabName = $(ev.currentTarget).attr('tab-name')
      @model.set(tab: tabName)
