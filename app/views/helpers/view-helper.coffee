module.exports = class ViewHelper
  initialize: (Handlebars)->
    Handlebars.registerPartial "sidebar_item", Templates.trainer.sidebar.sidebar_item

    Handlebars.registerHelper 'ifNot', (v1, v2, options) ->
      if v1 is v2
        return options.inverse @
      else
        options.fn @

    Handlebars.registerHelper 'withProfile', (options) ->
      context = App.profileModel.attributes
      Handlebars.helpers.with.call(this, context, options)

    Handlebars.registerHelper 'getAge', (date, options) ->
      if date
        age = moment().diff(date, 'years')

    Handlebars.registerHelper 'getSex', (gender, options) ->
      if gender
        'Women'
      else
        'Man'

    Handlebars.registerHelper "prettifyDate", (timestamp) ->
      moment(new Date(timestamp)).fromNow()
