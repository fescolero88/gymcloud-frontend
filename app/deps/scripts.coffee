define [
  'expose?$!jquery'
  'expose?_!lodash'
  'expose?Backbone!backbone'
  'underscore.string'
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
)->
  _.mixin Strings.exports()
