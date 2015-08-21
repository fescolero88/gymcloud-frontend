define [
  'expose?$!jquery'
  'expose?_!lodash'
  'expose?Backbone!backbone'
  'underscore.string'
  'underscore.inflections'
  'backbone-validation'
  'backbone.marionette'
  'expose?Handlebars!handlebars'
  'bootstrap'
  'selectize'
  'datetimepicker'
  'nanoscroller'
  'jquery-sortable'
], (
  $
  _
  Backbone
  Strings
  Inflections
)->
  _.mixin Inflections
  _.mixin Strings.exports()
