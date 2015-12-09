define [
  'jquery_original'
  './base'
], (
  $
  base
) ->
  config = base.production
  config.api.url = config.api.urls['alpha_staging']
  config