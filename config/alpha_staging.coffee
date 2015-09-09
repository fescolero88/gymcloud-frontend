define [
  'jquery_original'
  './base'
], (
  $
  base
) ->

  config = $.extend(true, {}, base)
  config.env = 'production'
  config.api.url = config.api.urls['alpha_staging']
  config
