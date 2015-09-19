define [
  'spinner'
], (
  Spinner
)->

  (App) ->

    opts =
      lines: 7
      length: 0
      width: 19
      radius: 17
      scale: 2.25
      corners: 1
      color: '#3398db'
      opacity: 0
      rotate: 0
      direction: 1
      speed: 1.5
      trail: 100
      fps: 20
      zIndex: 2e9
      className: 'spinner'
      top: '50%'
      left: '50%'
      shadow: true
      hwaccel: true
      position: 'absolute'

    spinner = new Spinner(opts)

    App.vent.on 'spinner:start', ->
      spinEl = document.getElementById('spinner')
      spinner.spin(spinEl)

    App.vent.on 'spinner:stop', ->
      spinner.stop()

    App.on 'before:start', ->
      App.vent.trigger('spinner:start')

    App.on 'started', ->
      App.vent.trigger('spinner:stop')

    loadingCount = 0

    $(document).ajaxStart ->
      if ++loadingCount is 1
        App.vent.trigger('spinner:start')

    $(document).ajaxComplete ->
      if App._isStarted && loadingCount > 0 && --loadingCount is 0
        App.vent.trigger('spinner:stop')
