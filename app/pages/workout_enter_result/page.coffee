define [
  'pages/base/page'
  './template'
], (
  BasePage
  template
  AddResultView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    initViews: ->
      root: ->
        console.log 'qwwer'
        view = new AddResultView
