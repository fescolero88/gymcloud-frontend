Handlebars = require('handlebars')

module.exports = (options) ->
  profileModel = App.request('data:profile')
  context = profileModel.attributes
  Handlebars.helpers.with.call(this, context, options)
