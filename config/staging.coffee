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
  config.env = 'staging'
  after(config)
