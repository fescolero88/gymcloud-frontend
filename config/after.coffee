define ->

  (config) ->

    config.api.url = config.api.urls[config.env]
    config.mobile.url = config.mobile.urls[config.env]
    config
