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
        window.location.replace(@url + @hash)
      ), 6000
      document.addEventListener 'visibilitychange', ->
        clearTimeout(id)
      setTimeout (=>
        window.location.replace(@path + @hash)
      ), 3000

    isMobile: ->
      !! @md.mobile()

    shouldRedirect: ->
      !! @path
