Backbone = require 'backbone'

module.exports = class GlobalProgramModel extends Backbone.Model
  urlRoot: '/api/mobile/programs/'
