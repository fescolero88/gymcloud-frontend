define [
  'deps/bundles/backbone/bundle'
  './original'
  'backbone.wreqr'
  'backbone.babysitter'
], (
  bBackbone
  oMarionette
)->

  oMarionette
  oMarionette.Backbone = bBackbone
  bBackbone.Marionette = oMarionette
  _.extend(oMarionette.View.prototype, bBackbone.Stickit.ViewMixin)
  oMarionette
