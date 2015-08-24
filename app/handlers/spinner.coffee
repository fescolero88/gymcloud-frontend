define ['spinner'], (Spinner)->
  (App) ->
    spinner = new Spinner
    spinEl = document.getElementById('center-spin')

    App.vent.on 'spinner:start', ->
      spinner.spin(spinEl)

    App.vent.on 'spinner:stop', ->
      spinner.stop()