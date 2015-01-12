Backbone = require 'backbone'

module.exports = class ProfileModel extends Backbone.Model
  url: '/api/mobile/me'
