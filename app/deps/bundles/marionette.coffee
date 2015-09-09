define [
  'deps/bundles/backbone'
  'backbone.marionette'
], (
  Backbone
  Marionette
)->

  Marionette
  _.extend(Marionette.View.prototype, Backbone.Stickit.ViewMixin)
  Marionette
