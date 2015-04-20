Marionette = require 'backbone.marionette'

class EmptyView extends Marionette.ItemView
  template: Templates.client.assigments_empty

  initialize: (data) =>
    @dataType = data.dataType

  templateHelpers: =>
    dataType: @dataType

class ClientEWPItemView extends Marionette.ItemView
  template: Templates.client.ewp_item
  tagName: 'li'
  className: 'row'

  initialize: (options) =>
    @dataType = options.dataType

  templateHelpers: =>
    dataType: @dataType

module.exports = class ClientEWPView extends Marionette.CompositeView
  template: Templates.client.ewp_list
  childView: ClientEWPItemView
  childViewContainer: 'ul'
  emptyView: EmptyView
  collectionEvents:
    sync: 'render'
  childViewOptions: =>
    dataType: @dataType

  emptyViewOptions: =>
    dataType: @dataType

  initialize: (data) =>
    @dataType = data.dataType

  templateHelpers: =>
    dataType: @dataType


