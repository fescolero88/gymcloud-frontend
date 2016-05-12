define [
  'config'
  'handlers/data'
  'handlers/ajax_setup'
  'handlers/form_validator'
  'handlers/jquery'
  'handlers/renderer'
  'handlers/others'
  'handlers/tour'
], (
  config
  dataHandler
  ajaxSetupHandler
  jqueryHandlers
  formValidatorHandler
  rendererHandler
  othersHandler
  tour
) ->

  (app) ->
    dataHandler(app)
    ajaxSetupHandler(app, config)
    jqueryHandlers(app)
    formValidatorHandler()
    rendererHandler(app)
    othersHandler(app)
    tour(app)
