define [
  'jquery_original'
  './base'
], (
  $
  base
) ->

  config = $.extend(true, {}, base)
  config.env = 'staging'
  config.api.url = config.api.urls[config.env]
  config
