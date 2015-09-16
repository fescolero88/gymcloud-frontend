define [
  'config'
  'modules/pre/redirect_to_mobile'
], (
  config
  RedirectToMobile
) ->

  new RedirectToMobile
    path: config.mobile.url
