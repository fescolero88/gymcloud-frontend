define [
  'pages/base/page'
  './template'
  'features/personal_entities/view'
], (
  BasePage
  template
  ListView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    init: ->
      _.defer => @model.set('state.subpage', @options.state)

    initCollection: ->
      user = App.request('current_user')
      user.personal_workouts

    initViews: ->
      list: ->
        new ListView
          collection: @model.get('data.collection')
          dataType: 'personal_workouts'