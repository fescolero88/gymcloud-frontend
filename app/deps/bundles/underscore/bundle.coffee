define [
  './original'
  'imports?underscore=deps/bundles/underscore/original!underscore.string'
  'imports?underscore=deps/bundles/underscore/original!underscore.inflections'
], (
  o_
  Strings
  Inflections
)->

  o_.mixin Inflections
  o_.mixin Strings.exports()
  o_
