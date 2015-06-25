Marionette = require 'backbone.marionette'

module.exports = class UiView extends Marionette.LayoutView

  template: Templates.prototype.ui

  attributes:
    class: 'gc-prototype-container'