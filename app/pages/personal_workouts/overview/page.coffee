define [
  'pages/base/page'
  './template'
  'models/personal_workout'
  './overview/view'
], (
  BasePage
  template
  PersonalWorkout
  OverviewView
) ->

  class Page extends BasePage

    behaviors:

      navigate_back: true
      mobile_only_features: true
      stickit:
        model: ->
          @model.get('data.model')
        bindings:
          'span.name': 'name'
          'button[data-action="edit"]':
            observe: 'id'
            visible: ->
              can('update', @model.get('data.model'))

    template: template

    regions:
      page_content: 'region[data-name="page_content"]'

    events:
      'click button[data-action="edit"]': (ev) ->
        model = @model.get('data.model')
        App.request 'modal:confirm',
          title: "Edit #{model.get('name')}?"
          content:
            '''You are editing ONLY the client's copy of this workout.
            Select UPDATE to continue.'''
          confirmBtn: 'Update'
          confirmCallBack: ->
            path = "#personal_workouts/#{model.id}/edit"
            App.vent.trigger('redirect:to', path, replace: false)

    initModel: ->
      new PersonalWorkout
        id: @options.id

    initViews: ->
      overview: ->
        new OverviewView
          model: @model.get('data.model')
