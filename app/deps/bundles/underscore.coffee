define [
  'lodash'
  'imports?underscore=lodash!underscore.string'
  'imports?underscore=lodash!underscore.inflections'
], (
  _
  Strings
  Inflections
)->

  _.mixin Inflections
  _.mixin Strings.exports()
  _
