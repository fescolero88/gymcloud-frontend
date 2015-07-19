Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

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
      @collection = new Backbone.Collection(@model.get('items') || {})
      key = @model.get 'key'

      # create listener specific to this folder
      App.vent.on "#{@type}:folder:#{key}:model:added", @addOne

  destroy: ->
    if @model.get 'isFolder'
      App.vent.off "#{@type}:folder:#{model.get 'key'}:model:added", @addOne

  addOne: (model) =>
    @collection.add model

module.exports = class SidebarEntity extends Marionette.CompositeView

  template: require('templates/trainer/sidebar/sidebar_entity')

  className: 'gc-sidebar-cat'

  childView: SidebarEntityItem

  childViewContainer: '.gc-sidebar-sub'

  initialize: (options) ->
    @type = options.type
    App.vent.on "#{@type}:model:added", @addOne

  childViewOptions: ->
    type: @type

  destroy: ->
    App.vent.off "#{@type}:model:added", @addOne

  templateHelpers: ->
    type: @type

  addOne: (model) =>
    @collection.add(model)
