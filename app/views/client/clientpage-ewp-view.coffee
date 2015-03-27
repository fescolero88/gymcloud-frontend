Marionette = require 'backbone.marionette'

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
  collectionEvents:
    sync: 'render'
  childViewOptions: =>
    dataType: @dataType

  initialize: (data) =>
    @dataType = data.dataType

  templateHelpers: =>
    dataType: @dataType


