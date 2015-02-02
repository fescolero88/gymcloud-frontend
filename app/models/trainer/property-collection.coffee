PropertyModel = require 'models/trainer/property-model'
CustomCollection = require 'models/general/custom-collection'

module.exports = class PropertyCollection extends CustomCollection
  url: '/api/mobile/properties'
  model: PropertyModel
