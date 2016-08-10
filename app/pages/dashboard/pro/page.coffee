define [
  'pages/base/page'
  './template'
  'features/dashboard/pro_model'
], (
  BasePage
  template
  ProDashboardModel
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'


    initModel: ->
      new ProDashboardModel({}, user_id: App.request('current_user_id'))

    initViews: ->
      root: ->
