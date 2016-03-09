define [
  'pages/base/page'
  './template'
  'models/client'
  'features/profile/header/view'
  'features/profile/personal_assignments/view'
  'features/profile/activity/view'
], (
  BasePage
  template
  Client
  HeaderView
  AssignedTemplatesLayoutView
  ActivityView
) ->

  class Page extends BasePage

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    behaviors:

      navigate_back: true

      navigation_content_tabs:
        data: [
            id: 'programs'
            title: 'Programs'
          ,
            id: 'workouts'
            title: 'Workouts'
        ]

      regioned:
        views: [
            region: 'header'
            klass: HeaderView
            options: ->
              model: @model.get('data.model')
          ,
            region: 'activity'
            klass: ActivityView
            options: ->
              user: @model.get('data.model')
        ]

    events:
      'click .gc-content-nav-delete': '_deleteButtonClick'
      'click .gc-content-nav-add': '_assignNewOne'

    init: ->
      _.defer => @model.set('state.subpage', @options.state)

    initModel: ->
      user = App.request('current_user')
      user.clients.get(@options.id) || new Client(id: @options.id)

    initViews: ->
      model = @model.get('data.model')
      programs: ->
        new AssignedTemplatesLayoutView
          model: model
          viewType: 'personal_programs'
      workouts: ->
        new AssignedTemplatesLayoutView
          model: model
          viewType: 'personal_workouts'

    _deleteButtonClick: ->
      view = @getRegion('page_content').currentView
      view.trigger('nav:delete')

    _assignNewOne: ->
      view = @getRegion('page_content').currentView
      view.trigger('nav:assign')