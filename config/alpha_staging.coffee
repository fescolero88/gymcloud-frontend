define [
  'jquery_original'
  './base'
  './after'
], (
  $
  base
  after
) ->

  config = $.extend(true, {}, base)
  config.env = 'production'
  after(config)
  config.api.url = config.api.urls['alpha_staging']
  config
