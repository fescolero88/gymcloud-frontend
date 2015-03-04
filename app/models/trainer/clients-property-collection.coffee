PropertyModel = require 'models/trainer/property-model'
CustomCollection = require 'models/general/custom-collection'

module.exports = class ClientsPropertyCollection extends CustomCollection

  urlRoot: '/api/mobile/clients'

  model: PropertyModel
