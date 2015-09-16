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
  config.env = 'development'
  after(config)
