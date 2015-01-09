Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

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
    new_group = new Backbone.Model()
    new_group.set 'name', params.name
    new_group.url = '/api/mobile/client_groups'
    new_group.save().then =>
      if params.avatar[0].files[0]
        data = new FormData()
        data.append("avatar", params.avatar[0].files[0])
        # Get a new avatar url and then rerender itemview
        $.ajax
          url: "#{new_group.url}/#{new_group.id}/avatar"
          type: 'PUT'
          data: data
          cache: false
          dataType: 'json'
          processData: false
          contentType: false
    @collection.unshift new_group
