module.exports = class ViewHelper
  initialize: (Handlebars)->
    Handlebars.registerPartial "sidebar_item", require '../../templates/trainer/sidebar/sidebar_item'

    Handlebars.registerHelper 'ifNot', (v1, v2, options) ->
      if v1 is v2
        return options.inverse @
      else
        options.fn @

    Handlebars.registerHelper 'withProfile', (options) ->
      context = App.profile_model.attributes
      Handlebars.helpers.with.call(this, context, options)

