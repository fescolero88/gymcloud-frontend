Marionette = require 'backbone.marionette'
Backbone = require 'backbone'

ClientCollection = require 'models/trainer/client-collection'

module.exports = class SendMessageModalView extends Marionette.ItemView
  className: 'modal-dialog'
  template: Templates.trainer.clients.send_message_modal

  initialize: (data)->
    @selectedItems = data.selectedItems

  onShow: ->
    @initSearchSelect()

  ui:
    'liveSearch':   '.live-search'
    'form':         'form'
    'messageBody':  'textarea[name=body]'

  events:
    'click  .gc-send-message-none': 'selectNone'
    'click  .gc-send-message-all':  'selectAll'
    'submit form':                  'submitForm'

  searchItems: (models) ->
    listItems = []
    for model in models
      item = new Object
      item.id = model.get 'id'
      item.last_name = model.get 'last_name'
      item.first_name = model.get 'first_name'
      item.color = model.get 'avatar_background_color'
      item.url = model.get 'avatar_url'
      listItems.push item
    listItems

  initSearchSelect: =>
    clientCollection = new ClientCollection
    clientCollection.fetch().then =>
      options = @searchItems clientCollection.models
      this_ = @
      @ui.liveSearch.selectize
        plugins: ['remove_button']
        hideSelected: true
        valueField: 'id'
        labelField: 'first_name'
        searchField: ['first_name', 'last_name']
        options: options
        render:
          item: (item, escape) ->
            return "<div>" + escape(item.first_name) + ' ' + escape(item.last_name) + '</div>'
          option: (item, escape) ->
            return "<div><span class='avatar' style='background-color: " +  \
              item.color + ";'><img src='" + item.url + "'></span>" + \
              escape(item.first_name) + ' ' + escape(item.last_name) + '</div>'
      for item in @selectedItems
        @ui.liveSearch[0].selectize.addItem item

  selectNone: (ev) =>
    ev.preventDefault()
    @ui.liveSearch[0].selectize.clear()

  selectAll: (ev) =>
    ev.preventDefault()
    @ui.liveSearch[0].selectize.setValue(Object.keys(@ui.liveSearch[0].selectize.options))

  switchError: (error_msg, $inputGroup)=>
    if error_msg
      $inputGroup.removeClass('gc-valid').addClass('gc-invalid')
      $inputGroup.find('.gc-error-message').text(error_msg)
    else
      $inputGroup.removeClass('gc-invalid').addClass('gc-valid')
      $inputGroup.find('.gc-error-message').text("")

  submitForm: (ev) ->
    ev.preventDefault()
    isError = false
    clients = @ui.liveSearch.val()
    message = @ui.messageBody.val()
    if !clients.length
      @switchError 'Choose client', @ui.liveSearch.closest('.form-group')
      isError = true
    if !message.length
      @switchError 'Type message', @ui.messageBody.closest('.form-group')
      isError = true
    if !isError
      @switchError false, @ui.liveSearch.closest('.form-group')
      @switchError false, @ui.messageBody.closest('.form-group')
      data =
        body: message
      for clientId in clients.split(',')
        $.ajax
          url: "/api/mobile/conversations/users/#{clientId}/messages"
          type: 'POST'
          dataType: 'json'
          data: JSON.stringify data
        @trigger 'closeModal'
