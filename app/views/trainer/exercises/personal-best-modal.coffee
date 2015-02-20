Marionette = require 'backbone.marionette'
Backbone = require 'backbone'
ClientsPropertyCollection = require 'models/trainer/clients-property-collection'

class PersonalBestResultModel extends Backbone.Model

class PersonalBestResultCollection extends Backbone.Collection

class PersonalBestResultView extends Marionette.ItemView
  template: Templates.trainer.exercises.personal_best_modal_property
  tagName: 'li'
  className: 'row'

  modelEvents:
    "sync": "render"

  ui:
    deleteButton: '.gc-personl-best-modal-delete-property'

  events:
    "click @ui.deleteButton": "deleteProperty"

  deleteProperty: (ev) =>
    ev.preventDefault()
    @model.destroy()


module.exports = class PersonalBestModalView extends Marionette.CompositeView
  className: 'modal-dialog modal-md'
  template: Templates.trainer.exercises.personal_best_modal
  childView: PersonalBestResultView
  childViewContainer: 'ul'

  collectionEvents:
    "sync": "render"

  events:
    "submit @ui.groupForm": "submitGroupForm"
    "click @ui.clearAll": "clearAll"
    "click @ui.addPersonalBest": "addPersonalBest"

  ui:
    groupForm: "form"
    properties: 'select'
    propertyValue: '.gc-add-personal-best-property-value'
    clearAll: '.gc-add-personal-best-clear'
    addPersonalBest: '.gc-add-personal-best-add'
    date: '.gc-add-personal-best-date input'

  initialize: (data) =>
    @id = data.id
    @item_id = data.item_id
    @collection = new Backbone.Collection

  onShow: =>
    @properties = App.request("client:properties", @id) || new ClientsPropertyCollection
    if @properties.length
      @fillProperties()
    else
      @properties.url = "#{@properties.urlRoot}/#{@id}/properties"
      @properties.fetch().then =>
        App.request "client:properties:set", @id, @properties
        @fillProperties()

  fillProperties: =>
    @properties.each (p) =>
      $option = $('<option />')
      $option.attr('data-type', p.get('value_type'))
        .attr('value', p.get('id'))
        .text(p.get('name'))
      @ui.properties.append $option

  submitGroupForm: (ev) =>
    ev.preventDefault()
    if @validateResult()
      result = new PersonalBestResultModel
        property_id: @ui.properties.val()
        property_name: @ui.properties.find(':selected').text()
        value: @ui.propertyValue.val()
      resultView = new PersonalBestResultView model: result
      @collection.add result
      @ui.propertyValue.val ''

  validateResult: =>
    value = @ui.propertyValue.val()
    type = @ui.properties.find(':selected').data 'type'
    switch type
      when 'Numeric' then validator = /^\d+$/
      when 'String' then validator = /^.*$/
    if validator.test value
      @ui.propertyValue.removeClass 'gc-invalid'
      true
    else
      @ui.propertyValue.addClass 'gc-invalid'
      false

  validateDate: =>
    if @ui.date.val()
      @ui.date.parent().removeClass 'gc-invalid'
      true
    else
      @ui.date.parent().addClass 'gc-invalid'
      false

  clearAll: =>
    @collection.reset()

  addPersonalBest: =>
    if @validateDate() and @collection.length
      results = []
      @collection.each (c) =>
        results.push
          id: c.get('property_id')
          name: c.get('property_name')
          value: c.get('value')
      data =
        results: results
        item_id: @item_id
        id: @id
        created_at: @ui.date.val()
      $.ajax
        url: "/api/mobile/clients/#{@id}/exercises/#{@item_id}/records"
        type: 'POST'
        dataType: 'json'
        data: JSON.stringify data
        success: (data) =>
          @trigger 'personal_best:added', data


