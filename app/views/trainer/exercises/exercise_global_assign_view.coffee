Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientCollection = require 'models/trainer/client-collection'
GroupCollection = require 'models/trainer/group-collection'

AssigneesList = require 'models/trainer/global_exercise_assignees'

class ExerciseGlobalAssignClientsItemView extends Marionette.ItemView
  template: Templates.trainer.clients.exercise_assign_client_item
  tagName: 'li'
  className: 'row'

  ui:
    mark: '.gc-global-ewp-assigned-mark i'

  initialize: (data) =>
    @type = data.type
    @model.on 'assignees:loaded', @assigneesLoaded

  templateHelpers: =>
    type: @type

  events:
    'click a': 'toggleAssign'

  toggleAssign: (ev) =>
    ev.preventDefault()
    assigned = @ui.mark.hasClass 'active'
    @ui.mark.toggleClass 'active'
    @trigger 'client:assign:toggle', assigned

  assigneesLoaded: () =>
    @ui.mark.addClass 'active'

class ExerciseGlobalAssignClientsListView extends Marionette.CompositeView
  template: Templates.trainer.clients.universal_clients_list
  childView: ExerciseGlobalAssignClientsItemView
  childViewContainer: 'ul'
  childViewOptions: =>
    type: @type

  initialize: (data) =>
    @type = data.type
    @on 'assignees:loaded', @assigneesLoaded

  templateHelpers: =>
    type: @type

  childEvents:
    'client:assign:toggle': 'toggleAssign'

  toggleAssign: (view, assigned) =>
    @trigger 'client:assign:toggle', view.model, assigned

  assigneesLoaded: (ids) =>
    _this = @
    $.each ids, (i, v) =>
      _this.collection.where({id: v})[0].trigger 'assignees:loaded'

module.exports = class ExerciseGlobalAssignView extends Marionette.LayoutView
  template: Templates.trainer.exercises.exercise_global_assign
  className: 'gc-exercises-assign-view'

  ui:
    clientsRegion: "#clients-region"
    groupsRegion: "#groups-region"
    marksWrappers: '.gc-global-ewp-assigned-mark'

  regions:
    clients: '@ui.clientsRegion'
    groups: '@ui.groupsRegion'

  initialize: (data) =>
    @item_id = data.model.get 'id'

  onShow: =>
    clientsCollection = new ClientCollection
    clientsCollection.fetch()
    clientsList = new ExerciseGlobalAssignClientsListView
      collection: clientsCollection
      type: 'Individuals'
    @clients.show clientsList
    @listenTo clientsList, 'client:assign:toggle', @toggleAssign

    groupCollection = new GroupCollection
    groupCollection.fetch()
    groupsList = new ExerciseGlobalAssignClientsListView
      collection: groupCollection
      type: 'Groups'
    @groups.show groupsList
    @listenTo groupsList, 'client:assign:toggle', @toggleAssign

    @assignees = new AssigneesList()
    @assignees.url = @assignees.urlRoot + "/exercises/#{@item_id}/assignees"
    @assignees.fetch().then =>
      clientsList.trigger 'assignees:loaded', @assignees.get 'clients'
      groupsList.trigger 'assignees:loaded', @assignees.get 'client_groups'

  toggleAssign: (model, assigned) =>
    client_type_text = if model.get('clients') then "group" else "client"
    action_type_text = if assigned then "unassigned from" else "assigned to"
    message = "This exercise was #{action_type_text} this #{client_type_text}"
    url = ''
    id = model.get 'id'
    clientsType = if model.get('clients') then "client_groups" else "clients"
    if assigned
      url = "/api/mobile/exercises/#{@item_id}/assignees/bulk_unassign"
    else
      url = "/api/mobile/exercises/#{@item_id}/assignees/bulk_assign"
    data =
      client_ids: if (not model.get('clients')) then [id] else []
      client_group_ids: if model.get('clients') then [id] else []
    $.ajax
      url: url
      type: 'POST'
      dataType: 'json'
      data: JSON.stringify data
      success: (data) =>
        App.request 'messenger:show',
          hideAfter: 5
          message: message
          type: 'info'
