Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

class EWPGlobalItemView extends Marionette.ItemView

  template: require('templates/trainer/global_ewp/ewp_single_item')

  tagName: 'li'

  className: 'row'

  ui:
    checkbox: '.gc-exercises-chb input'

  events:
    'click @ui.checkbox': 'itemChecked'

  initialize: (options) =>
    @type = options.type

  templateHelpers: ->
    type: @type

  itemChecked: (ev) =>
    @trigger 'item:clicked'

module.exports = class EWPGlobalListView extends Marionette.CompositeView

  template: require('templates/trainer/global_ewp/global_ewp_list')

  childView: EWPGlobalItemView

  childViewContainer: 'ul'

  collectionEvents:
    'sync': 'render'
    'highlight': 'highlightNew'

  ui:
    checkboxWrappers: '.gc-exercises-assign-list'

  childViewOptions: =>
    'type': @typeName

  childEvents:
    'item:clicked': 'itemSelected'

  initialize: (data) =>
    @on 'items:delete', @deleteItems
    @typeName = data.type

  itemSelected: =>
    @trigger 'item:clicked'

  highlightNew: (model) =>
    if model
      $row = @ui.checkboxWrappers.find("[data-id=#{model.id}]").closest('.row')
      $row.addClass 'active'
      $('html, body').animate({
        scrollTop: $row.offset().top
      }, 1000);
      setTimeout =>
          $row.removeClass 'active'
        , 3000

  deleteItems: (ids) =>
    for key in ids
      model = @collection.where({key: key})[0]
      type = if model.get('isFolder') then "folders" else @typeName
      model.url = "/api/mobile/#{type}/#{model.get 'key'}"
      $.ajax
        method: 'DELETE'
        url: model.url
      model.destroy()
    App.request('data:reload', @typeName, App.request "data:#{@typeName}:root").then ->
      App.request 'messenger:show',
        hideAfter: 5
        message: "Item(s) was deleted"
        type: 'info'
