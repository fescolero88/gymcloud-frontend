SidebarChildItems = require 'collections/sidebar_child_items'

class SidebarEntityItem extends Marionette.CompositeView

  template: require('templates/trainer/sidebar/sidebar_item')

  childView: SidebarEntityItem

  childViewContainer: '.gc-sidebar-sub'

  childViewOptions: ->
    type: @type

  templateHelpers: ->
    type: @type

  initialize: (options) ->
    @type = options.type
    if @model.get 'isFolder'
      @collection = new SidebarChildItems(@model.get('items') || {})

      key = @model.get 'key'
      # create listener specific to this folder
      App.vent.on "#{@type}:folder:#{key}:model:added", @addOne
      App.vent.on "#{@type}:folder:#{key}:model:removed", @removeModel

  onDestroy: ->
    if @model.get 'isFolder'
      App.vent.off "#{@type}:folder:#{@model.get 'key'}:model:added", @addOne
      App.vent.off "#{@type}:folder:#{@model.get 'key'}:model:removed", @removeModel

  addOne: (model) =>
    @collection.add model

  removeModel: (param) =>
    @collection.remove(param.get('key'))

module.exports = class SidebarEntity extends Marionette.CompositeView

  template: require('templates/trainer/sidebar/sidebar_entity')

  className: 'gc-sidebar-cat'

  childView: SidebarEntityItem

  childViewContainer: '.gc-sidebar-sub'

  initialize: (options) ->
    @type = options.type
    App.vent.on "#{@type}:model:added", @addOne
    App.vent.on "#{@type}:model:removed", @removeOne

  childViewOptions: ->
    type: @type

  destroy: ->
    App.vent.off "#{@type}:model:added", @addOne
    App.vent.off "#{@type}:model:removed", @removeOne

  templateHelpers: ->
    type: @type

  addOne: (model) =>
    @collection.add(model)

  removeOne: (model) =>
    @collection.remove(model.get('key'))
