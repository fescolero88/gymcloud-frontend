define [
  'deps/bundles/backbone/bundle'
  './original'
  './dirty_hack'
  'deps/behaviors'
  'backbone.wreqr'
  'backbone.babysitter'
], (
  bBackbone
  oMarionette
  DirtyHack
  behaviors
)->

  oMarionette
  oMarionette.Backbone = bBackbone
  bBackbone.Marionette = oMarionette
  _.extend(oMarionette.View.prototype, bBackbone.Stickit.ViewMixin)
  DirtyHack(oMarionette)
  oMarionette.Behaviors.behaviorsLookup = behaviors
  oMarionette
