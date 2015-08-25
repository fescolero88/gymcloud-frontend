define [
  './base'
], (
  base
) ->

  config = $.extend(true, {}, base)
  config.env = 'production'
  config.api.url = config.api.urls[config.env]
  config
