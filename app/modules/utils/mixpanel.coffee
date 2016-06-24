define [
  'config'
  './mixpanel_init'
], (
  config
  init
) ->

  init: ->
    key = config.vendor.mixpanel?.key
    return unless key
    init(document, window.mixpanel || [])
    window.mixpanel.init(key)
