moment = require 'moment'

module.exports = class ViewHelper
  initialize: (Handlebars)->
    Handlebars.registerPartial "sidebar_item", Templates.trainer.sidebar.sidebar_item

    Handlebars.registerHelper 'ifNot', (v1, v2, options) ->
      if v1 is v2
        return options.inverse @
      else
        options.fn @

    Handlebars.registerHelper "ifEqual", (v1, v2, options) ->
      if v1 is v2
        options.fn @
      else
        return options.inverse @

    Handlebars.registerHelper 'withProfile', (options) ->
      profileModel = App.request('data:profile')
      context = profileModel.attributes
      Handlebars.helpers.with.call(this, context, options)

    Handlebars.registerHelper 'getAge', (date, options) ->
      if date
        age = moment().diff(date, 'years')

    Handlebars.registerHelper 'getSex', (gender, options) ->
      map =
        false: 'Female'
        true: 'Male'
      map[gender]

    Handlebars.registerHelper "activityMessage", (item) ->
      activtyMapMessages =
        message_received:
          message: "Received message from"
          link: ->
            "<a href=#>#{item.sender_full_name}</a>"
        new_item_assigned:
          message: "Was assigned new"
          link: ->
            "#{item.context.assign_type} <a href=#>#{item.context.assign_name}</a>"
      activityLog = activtyMapMessages[item.type]
      """
        #{activityLog.message} #{activityLog.link()}
      """

    Handlebars.registerHelper "prettifyDate", (timestamp) ->
      moment(new Date(timestamp)).fromNow()

    Handlebars.registerHelper 'date', (timestamp) ->
      moment(timestamp).format "MMMM D, YYYY"


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


