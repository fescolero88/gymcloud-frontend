define [
  'mobile-detect'
], (
  MobileDetect
) ->

  class RedirectToMobile

    constructor: (options) ->
      @path = options.appPath
      @url = options.appUrl
      @hash = window.location.hash
      @agent = window.navigator.userAgent
      @md = new MobileDetect(@agent)
      @check()
      @

    check: ->
      @redirect() if @isMobile() and @shouldRedirect()

    redirect: ->
      id = setTimeout (=>
        window.location.replace(@url)
      ), 5000
      document.addEventListener 'visibilitychange', ->
        clearTimeout(id)
      window.location.replace(@path + @hash)

    isMobile: ->
      !! @md.mobile()

    shouldRedirect: ->
      !! @path
