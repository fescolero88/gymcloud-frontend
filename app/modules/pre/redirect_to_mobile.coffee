define [
  'mobile-detect'
], (
  MobileDetect
) ->

  class RedirectToMobile

    constructor: (options) ->
      @path = options.path
      @agent = window.navigator.userAgent
      @md = new MobileDetect(@agent)
      @check()
      @

    check: ->
      @redirect()  if @isMobile() and @shouldRedirect()

    redirect: ->
      window.location.replace(@path)

    isMobile: ->
      !! @md.mobile()

    shouldRedirect: ->
      !! @path
