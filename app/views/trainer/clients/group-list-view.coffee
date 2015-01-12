Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

GroupModel = require 'models/trainer/group-model'

module.exports = class GroupItemView extends Marionette.ItemView
  template: Templates.trainer.clients.group_item
  tagName: 'li'
  className: 'row'

  modelEvents:
    "sync": "render"

module.exports = class GroupListView extends Marionette.CompositeView
  template: Templates.trainer.clients.group_list
  childView: GroupItemView
  childViewContainer: 'ul'

  initialize: =>
    @on 'rm-group', @rmGroup
    @on 'submit-group-form', @submitGroupForm

  rmGroup: =>
    for check in @$el.find('input[type=checkbox]')
      if $(check).is(':checked')
        model = @collection.get $(check).data('id')
        model.destroy()

  submitGroupForm: (params)->
    newGroup = new GroupModel
    newGroup.set 'name', params.name
    newGroup.save().then =>
      if params.avatar[0].files[0]
        data = new FormData()
        data.append("avatar", params.avatar[0].files[0])
        # Get a new avatar url and then rerender itemview
        $.ajax
          url: "#{newGroup.url}/#{newGroup.id}/avatar"
          type: 'PUT'
          data: data
          cache: false
          dataType: 'json'
          processData: false
          contentType: false
    @collection.unshift newGroup
