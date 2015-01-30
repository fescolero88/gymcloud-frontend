Backbone = require 'backbone'
PropertyModel = require 'models/trainer/property-model'

module.exports = class PropertyCollection extends Backbone.Collection
  url: '/api/mobile/properties'
  model: PropertyModel
