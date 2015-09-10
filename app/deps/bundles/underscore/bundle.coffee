define [
  './original'
  'imports?underscore=lodash!underscore.string'
  'imports?underscore=lodash!underscore.inflections'
], (
  o_
  Strings
  Inflections
)->

  o_.mixin Inflections
  o_.mixin Strings.exports()
  o_
