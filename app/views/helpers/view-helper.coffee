module.exports = class ViewHelper
  initialize: (Handlebars)->
    Handlebars.registerPartial "sidebar_item", Templates.trainer.sidebar.sidebar_item

    Handlebars.registerHelper 'ifNot', (v1, v2, options) ->
      if v1 is v2
        return options.inverse @
      else
        options.fn @

    Handlebars.registerHelper 'withProfile', (options) ->
      profileModel = App.request('data:profile')
      context = profileModel.attributes
      Handlebars.helpers.with.call(this, context, options)

    Handlebars.registerHelper 'getAge', (date, options) ->
      if date
        age = moment().diff(date, 'years')

    Handlebars.registerHelper 'getSex', (gender, options) ->
      map =
        false: 'Women'
        true: 'Man'
      map[gender]

    Handlebars.registerHelper "prettifyDate", (timestamp) ->
      moment(new Date(timestamp)).fromNow()

    Handlebars.registerHelper 'ifCond', (v1, operator, v2, options)->
      switch operator
          when '==', '==='
              return if v1 is v2 then options.fn @ else options.inverse @
          when '<'
              return if v1 < v2 then options.fn @ else options.inverse @
          when '<='
              return if v1 <= v2 then options.fn @ else options.inverse @
          when '>'
              return if v1 > v2 then options.fn @ else options.inverse @
          when '>='
              return if v1 >= v2 then options.fn @ else options.inverse @
          when '&&'
              return if v1 && v2 then options.fn @ else options.inverse @
          when '||'
              return if v1 || v2 then options.fn @ else options.inverse @
          else
              return options.inverse @
