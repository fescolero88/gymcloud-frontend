PersonalBestModel = require 'models/trainer/personal-best-model'
CustomCollection = require 'models/general/custom-collection'

module.exports = class PersonalBestCollection extends CustomCollection
  urlRoot: '/api/mobile/clients'
  model: PersonalBestModel
